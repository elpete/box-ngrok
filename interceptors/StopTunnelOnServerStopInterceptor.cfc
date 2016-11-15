component {

    property name="ngrokService" inject="NgrokService@box-ngrok";

    function onServerStop( interceptData ) {
    	
		ngrokService.ifNgrokIsRunning( function() {
			// Search for a tunnel named the same as the server we just stopped
			var tunnelToStop = ngrokService.getTunnelNames().filter( function( tunnelName ) {
				return findNoCase( interceptData.serverInfo.name, tunnelName ) > 0;
			} );
			// If we found one, stop all tunnels.
			// (We only allow one tunnel at a time anyway right now)
			if( tunnelToStop.len() ) {
	        	ngrokService.stopAllRunningTunnels();				
			}
        
 		} );
    }

}
