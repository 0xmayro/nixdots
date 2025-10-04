# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
      default = "2";
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "seraphim"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.graphics.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mayro = {
    isNormalUser = true;
    description = "May Ronen";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users.greeter = {
    isSystemUser = true;
    description = "Greetd Greeter User";
    group = "greeter";
    shell = pkgs.bash;
  };
  users.groups.greeter = { };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables = rec {
    VISUAL = "nvim";
    EDITOR = VISUAL;
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_config_HOME = "$HOME/.config";
  };
  xdg.portal = {
    enable = true;
    extraPortals =
      let inherit (pkgs) xdg-desktop-portal-wlr xdg-desktop-portal-gtk;
      in [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libsecret
    gnome-keyring
    curl
    wget
    stow
    llvm
    clang
    clang-tools
    wl-clipboard
    clipman
    cliphist
    brightnessctl
    rofi-wayland
    fuzzel
    wlogout
    waybar
    swww
    greetd.greetd
    greetd.tuigreet

    alacritty
    starship
    zoxide
    atuin
    nushell
    fish
    tmux

    vim
    neovim

    syncthingtray
    keepassxc
    firefox
    libreoffice-fresh
    krita
    inkscape
  ];

  programs.nano.enable = false;

  programs.river = {
    enable = true;
    xwayland.enable = true;
  };

  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    config = { credential.helper = "libsecret"; };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    open-fonts
    openmoji-color

    nerd-fonts._0xproto
    nerd-fonts.meslo-lg
    nerd-fonts.symbols-only
  ];

  # List services that you want to enable
  security.rtkit.enable = true;

  security.pam.services = { login.enableGnomeKeyring = true; };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd river";
        user = "greeter";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.power-profiles-daemon.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # recommended to leave at the default value ("25.05").
  # Before changing read the docs: `man configuration.nix`.
  system.stateVersion = "25.05";
}
