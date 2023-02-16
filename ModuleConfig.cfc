component {

    function configure() {
        settings = {
            ngrokPath = "#modulePath#/bin/#getNgrokBinaryName()#"
        };

        interceptors = [
            { class = "#moduleMapping#.interceptors.StopTunnelOnServerStopInterceptor" }
        ];
    }

    function onLoad() {
      var fs = wirebox.getInstance( "FileSystem" );
      if ( fs.isMac() ) {
            cfexecute(
                name = "chmod",
                arguments = "755 #modulePath#/bin/#getNgrokBinaryName()#",
                timeout = 1
            );
        }
    }

    private string function getNgrokBinaryName() {
        var fs = wirebox.getInstance( "FileSystem" );
        if ( fs.isWindows() ) {
            return "ngrok-windows.exe";
        }
        if ( fs.isLinux() ) {
            return isArm() ? "ngrok-linux-arm" : "ngrok-linux-intel";
        }
        if ( fs.isMac() ) {
            return isArm() ? "ngrok-mac-arm" : "ngrok-mac-intel";
        }
        throw( "Unsupported platform" );
    }

    private boolean function isArm() {
        var systemSettings = wirebox.getInstance( "SystemSettings" );
        return systemSettings.getSystemSetting( 'os.arch', '' ).findNoCase( 'arm' ) || systemSettings.getSystemSetting( 'os.arch', '' ).findNoCase( 'aarch' );
    }

}
