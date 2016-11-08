component {

    property name="ngrokService" inject="NgrokService@box-ngrok";

    function onServerStop( interceptData ) {
        var tunnelToStop = ngrokService.getTunnelNames().filter( function( tunnelName ) {
            return findNoCase( interceptData.serverInfo.name, tunnelName ) > 0;
        } );

        tunnelToStop.each( function( tunnel ) {
            ngrokService.stopTunnel( tunnel );
        } );
    }

}