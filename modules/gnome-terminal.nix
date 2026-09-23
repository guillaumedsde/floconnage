{ pkgs, ... }: {
  programs.gnome-terminal = {
    enable = true;
    themeVariant = "system";
    profile."dd17b21f-e2ce-4efb-9e9e-783a5527bacf" = {
      visibleName = "default";
      default = true;
      scrollbackLines = 20000;
      font = "Fira Code 12";
    };
  };
  # gnome-terminal is D-Bus activated: the client asks systemd to start
  # `gnome-terminal-server.service`. Nix profiles install that unit in
  # `lib/systemd/user/`, which the systemd user manager does not scan on
  # Ubuntu, so activation fails with "Unit gnome-terminal-server.service
  # not found". Mirror the upstream unit here so it lands in
  # ~/.config/systemd/user/. No [Install] section: it is started on demand
  # by D-Bus, not at login.
  systemd.user.services.gnome-terminal-server = {
    Unit = {
      Description = "GNOME Terminal Server";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Slice = "app-org.gnome.Terminal.slice";
      Type = "dbus";
      BusName = "org.gnome.Terminal";
      ExecStart = "${pkgs.gnome-terminal}/libexec/gnome-terminal-server";
      TimeoutStopSec = "5s";
      KillMode = "process";
    };
  };
}
