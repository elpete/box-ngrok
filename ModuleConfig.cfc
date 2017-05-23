component {

    function configure() {
        settings = {
            ngrokPath = "#modulePath#/bin/#getNgrokBinaryName()#"
        };

        interceptors = [
            { class = "#moduleMapping#.interceptors.StopTunnelOnServerStopInterceptor" }
        ];
    }
    function onLoad(){
      var fs = wirebox.getInstance( "FileSystem" );
      if ( fs.isMac() ) {
            cfexecute(
                variable = "standardOutput",
                name = "chmod",
                arguments = "755 #modulePath#/bin/#getNgrokBinaryName()#",
                timeout = 1
            );
        }
    }

    private string function getNgrokBinaryName() {
        var fs = wirebox.getInstance( "FileSystem" );
        if ( fs.isWindows() ) return "ngrok-windows.exe";
        if ( fs.isLinux() ) return "ngrok-linux";
        if ( fs.isMac() ) return "ngrok-mac";
        return "ngrok";
    }

}