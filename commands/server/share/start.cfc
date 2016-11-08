/**
* Shares the current directory's server via ngrok.
* Make sure you are running this command in the root of your app with a server started.
*
* @aliases "share"
*/
component {

    property name="serverService" inject="ServerService";
    property name="ngrokService" inject="NgrokService@box-ngrok";

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

        ngrokService.ifNgrokIsNotRunning( function() {
            ngrokService.startNgrok();
            sleep( 1000 );
            ngrokService.ifNgrokIsNotRunning( function() {
                print.whiteOnRedLine( "Not sure what happened...." ).line();
                print.line( serializeJson( e ) ).line();
                return;
            } );
        } );

        var tunnelNames = ngrokService.getTunnelNames();

        if ( ngrokService.areTunnelsOpen() ) {
            print.blackOnYellowLine(
                "Only one server can be shared at a time.  Stopping any other tunnels."
            ).line();
            ngrokService.stopAllRunningTunnels();
        }

        var tunnel = ngrokService.createNewTunnel(
            name = serverInfo.name,
            port = serverInfo.port,
            isSSL = serverInfo.sslEnable
        );
        var tunnelUrl = tunnel.public_url;
        
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

    /**
    * AutoComplete server names
    */
    function serverNameComplete() {
        return serverService.getServerNames();
    }

}