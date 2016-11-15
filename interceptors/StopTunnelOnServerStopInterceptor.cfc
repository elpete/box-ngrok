component {

    property name="ngrokService" inject="NgrokService@box-ngrok";

    function onServerStop( interceptData ) {
        ngrokService.stopAllRunningTunnels();
    }

}
