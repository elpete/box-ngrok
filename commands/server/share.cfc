/**
* Shares the current directory's server via ngrok.
* Make sure you are running this command in the root of your app with a server started.
*
* @aliases "share"
*/
component {

    property name="serverService" inject="ServerService";
    property name="ngrokPath" inject="commandbox:moduleSettings:box-ngrok:ngrokPath";

    variables.tunnelsEndpoint = "http://127.0.0.1:4040/api/tunnels";

    /**
     * Share the current directory's server via ngrok
     *
     * @name.hint the short name of the server
     * @name.optionsUDF serverNameComplete
     * @directory.hint web root for the server
     * @serverConfigFile The path to the server's JSON file.
     * @verbose.hint    Show extra details
     * @json            Output the server data as json
     **/
     function run(
        string name,
        string directory,
        string serverConfigFile,
        boolean verbose = false,
        boolean JSON = false,
        boolean openBrowser = true
    ) {
        print.line(); // empty line for readablility

        var serverInfo = getServerInfo( arguments );

        if ( ! isServerRunning( serverInfo ) ) {
            print.cyanLine( "The server needs to be started first.  Doing that now." ).line();
            command( "server start" ).run();
            sleep( 1000 );
        }

        ifNgrokIsNotRunning( function() {
            startNgrok();
            sleep( 1000 );
            ifNgrokIsNotRunning( function() {
                print.whiteOnRedLine( "Not sure what happened...." ).line();
                print.line( serializeJson( e ) ).line();
                return;
            } );
        } );

        var tunnelNames = getTunnelNames();

        if ( areTunnelsOpen( tunnelNames ) ) {
            print.blackOnYellowLine(
                "Only one server can be shared at a time.  Stopping any other tunnels."
            ).line();
            stopAllRunningTunnels( tunnelNames );
        }

        var tunnelUrl = createNewTunnel( serverInfo );
        
        print.line( "Server shared successfully at:" );
        print.boldYellowLine( tunnelUrl );
        print.line();

        if ( openBrowser ) {
            fileSystemUtil.openBrowser( tunnelUrl );
        }
    }

    private struct function getServerInfo( required struct args ) {
        if( !isNull( args.directory ) ) {
            args.directory = fileSystemUtil.resolvePath( args.directory );
        } 
        if( !isNull( args.serverConfigFile ) ) {
            args.serverConfigFile = fileSystemUtil.resolvePath( args.serverConfigFile );
        }
        var serverDetails = serverService.resolveServerDetails( args );
        return serverDetails.serverInfo;
    }

    private boolean function isServerRunning( required struct serverInfo ) {
        return serverInfo.status == "running";
    }

    private void function ifNgrokIsNotRunning( callback ) {
        try {
            cfhttp( url = variables.tunnelsEndpoint, throwOnError = true );
        }
        catch ( any e ) {
            callback( e );
        }
    }

    private void function startNgrok() {
        var processBuilder = createObject( "java", "java.lang.ProcessBuilder" );
        processBuilder.init( [ "#ngrokPath#", "start", "--none" ] );
        processBuilder.start();
    }

    private array function getTunnelNames() {
        cfhttp( url = variables.tunnelsEndpoint, throwOnError = true );
        return deserializeJson( cfhttp.filecontent ).tunnels
            .map( function( tunnel ) {
                return tunnel.name;
            } );
    }

    private boolean function areTunnelsOpen( required array tunnels ) {
        return tunnels.len() > 0;
    }

    private void function stopAllRunningTunnels( required array tunnels ) {
        for ( var tunnel in tunnels ) {
            cfhttp( url = "#variables.tunnelsEndpoint#/#tunnel#" method = "DELETE" );
        }
    }

    private string function createNewTunnel( required struct serverInfo ) {
        cfhttp( url = variables.tunnelsEndpoint, method = "POST", throwOnError = true ) {
            cfhttpparam( type = "header" name = "content-type", value = "application/json" );
            cfhttpparam( type = "body", value = serializeJson( {
                "addr" = serverInfo.port,
                "proto" = "http",
                "name" = serverInfo.name
            } ) );
        }

        var response = deserializeJSON( cfhttp.filecontent );
        return serverInfo.sslEnable ?
            response.public_url :
            replace( response.public_url, "https://", "http://" );
    }

    /**
    * AutoComplete server names
    */
    function serverNameComplete() {
        return serverService.getServerNames();
    }

}