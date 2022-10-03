# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.grub.enable      = true;
  boot.loader.grub.device      = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone       = "Europe/Moscow";
  i18n.defaultLocale  = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ru_RU.utf8";
    LC_IDENTIFICATION = "ru_RU.utf8";
    LC_MEASUREMENT    = "ru_RU.utf8";
    LC_MONETARY       = "ru_RU.utf8";
    LC_NAME           = "ru_RU.utf8";
    LC_NUMERIC        = "ru_RU.utf8";
    LC_PAPER          = "ru_RU.utf8";
    LC_TELEPHONE      = "ru_RU.utf8";
    LC_TIME           = "ru_RU.utf8";
  };

  hardware = {
    opengl.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {

    enable       = true;
    layout       = "us";
    xkbVariant   = "";
    videoDrivers = [ "nvidia" ];

    displayManager = {
        lightdm.enable = true;
        defaultSession = "none+qtile";
    };

    windowManager = {

      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks     # is the package manager for Lua modules
          luadbi-mysql # database abstraction layer
        ];
      };

      xmonad = {
        enable                 = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
          haskellPackages.xmonad
        ];
      };

      qtile = {
        enable = true;
      };

    };

    desktopManager.plasma5 = {
      enable = true;
    };
  };

  virtualisation = {

    docker = {
      enable              = true;
    };

    virtualbox.host = {
      enable              = true;
      enableExtensionPack = true;
    };

  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable               = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ak = {
    isNormalUser = true;
    description = "Andrei Krasnoshchekov";
    extraGroups = [ "networkmanager" "wheel" "docker" "user-with-access-to-virtualbox"];
    packages = with pkgs; [
      alacritty
      bash bash-completion
      dmenu
      ripgrep silver-searcher emacs
      vscode
      firefox brave qutebrowser
      nodejs
      python
      qbittorrent transmission
      vlc
      rhythmbox deadbeef
      xournalpp
      okular evince zathura
      blender
      steam
      obs-studio
      musescore
      lutris
      nvtop
      goldendict
      pass keepassxc
      openssl
      postgresql_14
      nextcloud-client
      # -- haskell support --
      haskellPackages.haskell-language-server
      haskellPackages.hoogle
      cabal-install
      stack
    ];
  };

  services.postgresql = {
    enable      = true;
    package     = pkgs.postgresql_14;
    enableTCPIP = false;
    ensureDatabases = [
      "galatour"
      "guesthouse"
      "secondbrain"
    ];
    ensureUsers = [
      {
        name = "ak";
        ensurePermissions = {
          "DATABASE galatour"    = "ALL PRIVILEGES";
          "DATABASE guesthouse"  = "ALL PRIVILEGES";
          "DATABASE secondbrain" = "ALL PRIVILEGES";
        };
      }
    ];
    # authentication = pkgs.lib.mkOverride 10 ''
    #   local all all trust
    #   host  all all 127.0.0.1/32 trust
    #   host  all all ::1/128 trust
    # '';
  };

  # services.nextcloud-client = {                
  #   enable            = true;                   
  #   startInBackground = true;
  # };

  fonts.fonts = with pkgs; [
    # open-sans
    paratype-pt-sans
    paratype-pt-mono
    paratype-pt-serif
    source-code-pro
    source-sans-pro
    ubuntu_font_family
    noto-fonts-emoji
    vistafonts          # includes consolas?
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    tree
    git
    gnome.gedit konsole
    atool zip unzip
    sshfs
    ranger mc
    htop
    wget
    home-manager
  ];

  environment.variables = rec {
    EDITOR = "vim";
  };

  home-manager.users = {

    root = { pkgs, ... }: {
      programs = {
  
        vim = {
          enable   = true;
          plugins  = with pkgs.vimPlugins; [ vim-nix ];
          settings = {
            number = true;
          };
          # extraConfig = ''
          #   set mouse=a
          # '';
        };
  
        bash = {
          enable   = true;
          shellAliases = {
            l = "ranger --choosedir=/home/ak/.rangerdir; LASTDIR=`cat /home/ak/.rangerdir`; cd \"\${LASTDIR}\"";
            h = "history";
            H = "history | grep";
            r = "ranger";
          };
        };
  
      };

    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "22.05"; # Did you read the comment?

}
