/**
* Stops an Ngrok share and closes tunnel.
*
* @aliases "unshare"
*/
component {

    property name="ngrokService" inject="NgrokService@box-ngrok";

    variables.tunnelsEndpoint = "http://127.0.0.1:4040/api/tunnels";

    /**
     * Stop all ngrok tunnels currently running.
     **/
    function run() {
        print.line(); // empty line for readablility

        ngrokService.ifNgrokIsNotRunning( function() {
            print.line( "Ngrok isn't currently running, so there's nothing to do here!" ).line();
            return;
        } );

        print.line( "Stopping all running tunnels...." );
        ngrokService.stopAllRunningTunnels();
        print.greenLine( "Done!" ).line();
    }

}
