component singleton {

    property name="ngrokPath" inject="commandbox:moduleSettings:box-ngrok:ngrokPath";

    variables.tunnelsEndpoint = "http://127.0.0.1:4040/api/tunnels";
    variables.processs = '';

    public void function ifNgrokIsNotRunning( callback = function() {} ) {
        try {
            cfhttp( url = variables.tunnelsEndpoint, throwOnError = true );
        }
        catch ( any e ) {
            callback( e );
        }
    }

    public void function ifNgrokIsRunning( callback = function() {} ) {
        try {
            cfhttp( url = variables.tunnelsEndpoint, throwOnError = true );
        }
        catch ( any e ) {
            return;
        }

        callback();
    }

    public void function startNgrok() {
        var processBuilder = createObject( "java", "java.lang.ProcessBuilder" );
        processBuilder.init( [ "#ngrokPath#", "start", "--none" ] );
        variables.processs = processBuilder.start();
    }

    public array function getTunnels() {
        cfhttp( url = variables.tunnelsEndpoint, throwOnError = true ) {
            cfhttpparam( type = "header" name = "Content-Type", value = "application/json" );
        }
        return deserializeJSON( cfhttp.filecontent ).tunnels;
    }

    public array function getTunnelNames() {
        return getTunnels().map( function( tunnel ) {
            return tunnel.name;
        } );
    }

    public boolean function areTunnelsOpen() {
        return getTunnels().len() > 0;
    }

    public void function stopTunnel( required string tunnelName ) {
        cfhttp( url = "#variables.tunnelsEndpoint#/#tunnelName#" method = "DELETE" ) {
            cfhttpparam( type = "header" name = "Content-Type", value = "application/json" );
        }
    }

    public void function stopAllRunningTunnels() {
        getTunnelNames().each( stopTunnel );
        if( !isSimpleValue( variables.processs ) ) {
        	variables.processs.destroy();
        }
        
    }

    public struct function createNewTunnel(
        required string name,
        required string port, // May be host:port
        boolean isSSL = false,
        string protocol = "http"
    ) {
        cfhttp( url = variables.tunnelsEndpoint, method = "POST", throwOnError = true ) {
            cfhttpparam( type = "header" name = "content-type", value = "application/json" );
            cfhttpparam( type = "body", value = serializeJson( {
                "addr" = port,
                "proto" = protocol,
                "name" = name
            } ) );
        }

        var response = deserializeJSON( cfhttp.filecontent );
        if ( isSSL ) {
            response.public_url = replace(
                response.public_url, "https://", "http://"
            );
        }
        return response;
    }

}
