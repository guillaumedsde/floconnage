{ ... }: {
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      GUI = {
        AdvancedSettings = true;
        LaunchAtStartup = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome";
        MinimizeToTray = true;
        MinimizeOnStartup = false;
        ColorPasswords = true;
        CheckForUpdates = false;
      };
      Security = {
        ClearClipboardTimeout = 60;
        HideNotes = true;
        LockDatabaseIdle = false;
        HideTotpPreviewPanel = true;
      };
      FdoSecrets.Enabled = true;
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
        SearchInAllDatabases = true;
      };
      SSHAgent.Enabled = true;
      # home-manager makes KeepassXC configuration file read only
      # so KeeShare certificates can't be written to it
      # https://github.com/nix-community/home-manager/issues/8257
      KeeShare.Active = false;
    };
  };
}
