# ┌──────────────────────────────────────────────────────────────────────┐
# │  nix/<host>/configurations/hypr.nix — Hyprland + caelestia-shell     │
# │  Author:   Shiruvi                                                   │
# │  Repo:     https://github.com/Shiruvi/nixos                          │
# │  License:  GNU GPL v3.0 or later                                     │
# └──────────────────────────────────────────────────────────────────────┘
{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
  };

  # Hyprland started without UWSM does not activate graphical-session.target,
  # but xdg-desktop-portal has Requisite=graphical-session.target, so the
  # portal (screen sharing, OBS, file pickers) and every service WantedBy
  # that target (polkit agent) never start. graphical-session.target cannot
  # be started by hand, so a session target binds it; hyprland.lua starts
  # it on launch (same approach as Home Manager's systemd integration).
  systemd.user.targets.hyprland-session = {
    description = "Hyprland compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  # gpu-screen-recorder (used by `caelestia record`) captures monitors via
  # KMS; its gsr-kms-server needs cap_sys_admin, granted by this wrapper.
  programs.gpu-screen-recorder.enable = true;

  qt.enable = true;

  environment.systemPackages = [
    inputs.caelestia-shell.packages.${system}.with-cli
    # `with-cli` only puts the CLI on the shell's own PATH; install it
    # system-wide for keybinds (clipboard, emoji, record) and the terminal.
    inputs.caelestia-shell.inputs.caelestia-cli.packages.${system}.default
    pkgs.qtengine
    pkgs.darkly
    pkgs.cliphist
    pkgs.setxkbmap # us,ru keymap for XWayland, see hyprland.lua autostart
  ];
}
