# KeePassXC with a writable configuration file.
#
# home-manager's programs.keepassxc module links keepassxc.ini from the Nix
# store, making it read-only. KeePassXC then can't persist settings it saves
# at runtime, which silently breaks KeeShare: its own certificate
# (KeeShare/Own), the trusted foreign certificates (KeeShare/Foreign) and the
# master switch (KeeShare/Active) all live in keepassxc.ini.
# https://github.com/nix-community/home-manager/issues/8257
#
# This module therefore does not let home-manager link the file. Instead, an
# activation script installs a writable copy and merges the settings below
# into whatever KeePassXC has written since the last activation:
#
# - settings declared here always win on `home-manager switch`;
# - keys only present locally (KeeShare certificates, GUI tweaks, ...) are
#   preserved;
# - keys removed from `settings` are not removed from the file.
#
# Note: run `home-manager switch` while KeePassXC is closed, otherwise it may
# overwrite the merged file with its in-memory copy when it exits.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.keepassxc;

  iniFormat = pkgs.formats.ini { };
  managedSettings = iniFormat.generate "keepassxc-settings" cfg.settings;

  keepassxcDir = "${config.xdg.configHome}/keepassxc";
  keepassxcIni = "${keepassxcDir}/keepassxc.ini";
in
{
  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      # Write the config version upfront instead of letting KeePassXC
      # migrate the file on first start.
      General.ConfigVersion = 2;
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
      # Now that the config file is writable, KeePassXC can persist its
      # KeeShare certificates in it, so sharing can be enabled (but we
      # default to disabled)
      # KeeShare.Active =;
    };
  };

  # Don't let home-manager link a read-only keepassxc.ini into place.
  xdg.configFile."keepassxc/keepassxc.ini".enable = lib.mkForce false;

  # Install a writable keepassxc.ini instead, merging `settings` into the
  # existing file so that KeePassXC's own writes survive activations.
  home.activation.keepassxcWritableConfig = lib.mkIf (cfg.settings != { }) (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if [ -L "${keepassxcIni}" ]; then
        # Migration from the read-only symlink installed by home-manager.
        run rm -f "${keepassxcIni}"
      fi
      run mkdir -p "${keepassxcDir}"
      if [ -e "${keepassxcIni}" ]; then
        run ${lib.getExe pkgs.crudini} --merge "${keepassxcIni}" < "${managedSettings}"
      else
        run install -m 600 "${managedSettings}" "${keepassxcIni}"
      fi
    ''
  );
}
