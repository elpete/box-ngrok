component {

    function configure() {
        settings = {
            ngrokPath = "#modulePath#/bin/#getNgrokBinaryName()#"
        };

        interceptors = [
            { class = "#moduleMapping#.interceptors.StopTunnelOnServerStopInterceptor" }
        ];
    }

    private string function getNgrokBinaryName() {
        var fs = wirebox.getInstance( "FileSystem" );
        if ( fs.isWindows() ) return "ngrok-windows.exe";
        if ( fs.isLinux() ) return "ngrok-linux";
        if ( fs.isMac() ) return "ngrok-mac";
        return "ngrok";
    }

}