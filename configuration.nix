# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
    group = "greeter";
    shell = pkgs.bash;
  };

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
    extraPortals = let inherit(pkgs) xdg-desktop-portal-wlr xdg-desktop-portal-gtk; in [
      xdg-desktop-portal-wlr  
      xdg-desktop-portal-gtk
    ];
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
  greetd.agreety
  
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
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.nano.enable =  false;
  
  programs.river = {
    enable = true;
    xwayland.enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      command = "${pkgs.greetd}/bin/agreety --cmd river";
      user = "greeter";
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    config = {
      credential.helper = "libsecret";
    };
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable
  security.rtkit.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring = true;
  };
  services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     wireplumber.enable = true;
  };
  
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
