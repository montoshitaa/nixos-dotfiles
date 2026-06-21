{
  config,
  pkgs,
  lib,
  ...
}:

let
  # ── Theme derivations ───────────────────────────────────────────
  # Extracts Plasma desktop themes from the kde-themes/ tarballs
  # and makes them available in the nix store.

  purPurDayTheme = pkgs.stdenv.mkDerivation {
    name = "PurPurDay-Plasma-theme";
    src = ../../kde-themes/PurPurDay-Plasma.tar.gz;
    nativeBuildInputs = [ pkgs.gnutar ];
    sourceRoot = ".";
    unpackPhase = ''
      tar --no-selinux -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp -r PurPurDay-Plasma $out/
      cp PurPurDay-Plasma/colors $out/PurPurDayColor.colors
    '';
  };

  scratchyTheme = pkgs.stdenv.mkDerivation {
    name = "Scratchy-theme";
    src = ../../kde-themes/Scratchy.tar.gz;
    nativeBuildInputs = [ pkgs.gnutar ];
    sourceRoot = ".";
    unpackPhase = ''
      tar --no-selinux -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp -r Scratchy $out/
      cp Scratchy/colors $out/Scratchy.colors
    '';
  };

  # ── Active theme choice ─────────────────────────────────────────
  # Change this to switch between themes
  activeDesktopTheme = "PurPurDay-Plasma";
  activeColorScheme = "PurPurDayColor";
  activeIconTheme = "breeze-dark";
  activeWidgetStyle = "Breeze";
  activeWindowDecoration = "org.kde.breeze";
  activeLookAndFeel = "org.kde.breezedark.desktop";

  # ── KWin scripts to install and enable ──────────────────────────
  # Add package names from pkgs.kdePackages here.
  # Common examples:
  #   pkgs.kdePackages.krohnkite     → tiling window manager
  #   pkgs.kdePackages.bismuth       → tiling window manager
  #   pkgs.kdePackages.kwin-tiling   → lightweight tiling
  #   pkgs.kdePackages.sticky-window-snapping
  kwinScriptPackages = with pkgs.kdePackages; [
    # krohnkite
    # bismuth
    # kwin-tiling
  ];

  # KWin scripts to enable by plugin id (matches script's metadata.json KPlugin.Id)
  # These will be written to kwinrc [Plugins] section.
  # kwinScriptsEnabled = [
  #   "krohnkite"
  #   "bismuth"
  # ];

in
{
  # ── Packages ────────────────────────────────────────────────────

  home.packages =
    kwinScriptPackages
    ++ (with pkgs; [
      # Add any extra KDE packages here
      # kdePackages.plasma-thunderbolt  # Plasma integration for TB devices
      # kdePackages.kwalletmanager      # Wallet management GUI
      # kdePackages.spectacle           # Screenshot tool
      # kdePackages.dolphin             # File manager
      # kdePackages.kate                # Text editor
      # kdePackages.okular              # Document viewer
      # kdePackages.ark                 # Archive tool
      # kdePackages.gwenview            # Image viewer
    ]);

  # ── Qt / GTK theming bridge (only when Plasma is active) ────────
  # Uncomment if you want Qt/GTK apps to follow the KDE theme:
  # qt = {
  #   enable = true;
  #   platformTheme.name = "kde";
  #   style.name = "breeze";
  # };
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Breeze";
  #     package = pkgs.kdePackages.breeze-gtk;
  #   };
  # };

  # ── Theme installation ──────────────────────────────────────────
  # Installs plasma themes + color schemes to ~/.local/share/

  xdg.dataFile = {
    # Plasma Desktop Themes
    "plasma/desktoptheme/PurPurDay-Plasma".source = "${purPurDayTheme}/PurPurDay-Plasma";
    "plasma/desktoptheme/Scratchy".source = "${scratchyTheme}/Scratchy";

    # Color Schemes (extracted from the themes)
    "color-schemes/PurPurDayColor.colors".source = "${purPurDayTheme}/PurPurDayColor.colors";
    "color-schemes/Scratchy.colors".source = "${scratchyTheme}/Scratchy.colors";
  };

  # ── Plasma shell config ─────────────────────────────────────────
  # ~/.config/plasmarc
  # Controls the active Plasma desktop theme and shell behavior.

  xdg.configFile."plasmarc".text = ''
    [Theme]
    name=${activeDesktopTheme}

    [DialogShadows]
    themes=${activeDesktopTheme}
  '';

  # ── KDE global settings ─────────────────────────────────────────
  # ~/.config/kdeglobals
  # Controls color scheme, widget style, icons, fonts, etc.

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=${activeColorScheme}
    Name=${activeColorScheme}
    widgetStyle=${activeWidgetStyle}
    shadeSortColumn=true

    [Icons]
    Theme=${activeIconTheme}

    [KDE]
    LookAndFeelPackage=${activeLookAndFeel}
    widgetStyle=${activeWidgetStyle}
    contrast=4
    animationDurationFactor=0.3
  '';

  # ── KWin window manager config ──────────────────────────────────
  # ~/.config/kwinrc
  # Controls compositing, window decorations, effects, KWin scripts.

  xdg.configFile."kwinrc".text = ''
    [Compositing]
    Backend=OpenGL
    Enabled=true
    GLCore=true
    OpenGLIsUnsafe=false
    HiddenPreviews=5
    WindowsBlockCompositing=false

    [Effect-blur]
    BlurStrength=10
    NoiseStrength=2

    [Effect-slide]
    HorizontalGap=20
    VerticalGap=20

    [Effect-translucency]
    # Translucent moving windows
    MoveResize=80

    [Effect-windowview]
    BorderActivateAll=9

    [ElectricBorders]
    Bottom=None
    BottomLeft=None
    BottomRight=None
    Left=None
    Right=None
    Top=None
    TopLeft=None
    TopRight=None

    [MouseBindings]
    CommandAllKey=Alt
    CommandWindow3=Activate, raise and pass click
    CommandWindowWheel=Scroll

    [Plugins]
    blurEnabled=true
    colorpickerEnabled=false
    contrastEnabled=false
    dimscreenEnabled=true
    fallapartEnabled=false
    kwin4_effect_dimscreenEnabled=true
    kwin4_effect_eyeonscreenEnabled=false
    magnifierEnabled=false
    mouseclickEnabled=false
    mouseposEnabled=false
    outputlocatorEnabled=true
    overviewEnabled=true
    slidingpopupsEnabled=true
    snaphelperEnabled=true
    startupfeedbackEnabled=true
    stickyWindowSnappingEnabled=true
    trackmouseEnabled=false
    translucencyEnabled=true
    windowviewEnabled=true
    zoomEnabled=true

    [Script-${activeWindowDecoration}]
    borderSize=Normal
    borderSizeAuto=true

    [TabBox]
    BorderActivate=9
    DesktopMode=0
    SwitchingMode=0

    [Windows]
    AutoRaise=false
    AutoRaiseInterval=750
    BorderSnapZone=10
    CenterSnapZone=0
    DelayFocusInterval=0
    ElectricBorderCooldown=350
    ElectricBorderCornerRatio=0.25
    ElectricBorderDelay=150
    ElectricBorderMaximizing=true
    ElectricBorderTiling=true
    ElectricBorders=0
    FocusPolicy=FocusFollowsMouse
    FocusStealingPreventionLevel=1
    HideUtilityWindowsForInactive=true
    InactiveTabsSkipTaskbar=false
    MaximizeButtonLeftCommand=Maximize
    MaximizeButtonMiddleCommand=Maximize (vertical only)
    MaximizeButtonRightCommand=Maximize (horizontal only)
    NextFocusPrefersMouse=true
    Placement=Centered
    SeparateScreenFocus=false
    ShadeHover=false
    ShadeHoverInterval=250
    SnapZone=10
    XwaylandElectro=64

    [org.kde.kdecoration2]
    BorderSize=Normal
    BorderSizeAuto=true
    ButtonsOnLeft=MF
    ButtonsOnRight=IAX
    CloseOnDoubleClickOnMenu=false
    library=${activeWindowDecoration}
    theme=Breeze
  '';

  # ── KWin window rules ───────────────────────────────────────────
  # ~/.config/kwinrulesrc
  # Window-specific rules (always on top, size, position, etc.)

  xdg.configFile."kwinrulesrc".text = ''
    [1]
    Description=New Window Rule
    types=1

    [General]
    count=1
    rules=1
  '';

  # ── Taskbar / Panel config ───────────────────────────────────────
  # ~/.config/plasma-org.kde.plasma.desktop-appletsrc
  #
  # TIP: The easiest way to get your exact panel layout is:
  #   1. Configure Plasma manually the way you want
  #   2. Copy the generated file:
  #      cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc \
  #         ~/nixos-dotfiles/.plasma-layout
  #   3. Read it into nix with builtins.readFile
  #
  # Below is a minimal example with one bottom panel + taskbar + system tray.
  # Uncomment and adjust or replace with your captured layout.
  #
  # xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".text = ''
  #   [Containments][1]
  #   activityId=
  #   formfactor=2
  #   immutability=1
  #   lastScreen=0
  #   location=4
  #   plugin=org.kde.plasma.folder
  #   wallpaperplugin=org.kde.image
  #
  #   [Containments][2]
  #   activityId=
  #   formfactor=2
  #   immutability=1
  #   lastScreen=0
  #   location=4
  #   plugin=org.kde.panel
  #
  #   [Containments][2][Applets][3]
  #   immutability=1
  #   plugin=org.kde.plasma.kickoff
  #
  #   [Containments][2][Applets][4]
  #   immutability=1
  #   plugin=org.kde.plasma.icontasks
  #
  #   [Containments][2][Applets][5]
  #   immutability=1
  #   plugin=org.kde.plasma.systemtray
  #
  #   [Containments][2][Applets][6]
  #   immutability=1
  #   plugin=org.kde.plasma.digitalclock
  #
  #   [Containments][2][General]
  #   AppletOrder=3;4;5;6
  #
  #   [General]
  #   immutability=1
  # '';

  # ── KRunner config ──────────────────────────────────────────────
  # ~/.config/krunnerrc

  xdg.configFile."krunnerrc".text = ''
    [General]
    FreeFloating=true

    [Plugins]
    baloosearchEnabled=false
    bookmarksEnabled=false
    CharacterRunnerEnabled=false
    DictionaryEnabled=false
    krunner_dictionaryEnabled=false
    krunner_katesessionsEnabled=false
    locationsEnabled=false
    org.kde.activitiesEnabled=false
    recentdocumentsEnabled=false
    shellEnabled=true
    unitconverterEnabled=false
    webshortcutsEnabled=false
    windowsEnabled=true
  '';

  # ── SDDM / Lock screen ─────────────────────────────────────────
  # ~/.config/kscreenlockerrc

  xdg.configFile."kscreenlockerrc".text = ''
    [Daemon]
    Autolock=false
    LockOnResume=false
    Timeout=0
  '';

  # ── Splash screen ──────────────────────────────────────────────
  # ~/.config/ksplashrc

  xdg.configFile."ksplashrc".text = ''
    [KSplash]
    Theme=org.kde.breezedark.desktop
  '';

  # ── Fonts ──────────────────────────────────────────────────────
  # Uncomment to set system fonts:
  #
  # fonts.fontconfig.enable = true;
  #
  # And add to kdeglobals above:
  #   [General]
  #   font=Noto Sans,10,-1,5,50,0,0,0,0,0
  #   fixed=Hack,9,-1,5,50,0,0,0,0,0
  #   menuFont=Noto Sans,10,-1,5,50,0,0,0,0,0
  #   smallestReadableFont=Noto Sans,8,-1,5,50,0,0,0,0,0
  #   toolBarFont=Noto Sans,9,-1,5,50,0,0,0,0,0
  #   activeFont=Noto Sans,10,-1,5,50,0,0,0,0,0

  # ── Keyboard shortcuts ─────────────────────────────────────────
  # ~/.config/kglobalshortcutsrc
  # Uncomment to customize:
  #
  # xdg.configFile."kglobalshortcutsrc".text = ''
  #   [kwin]
  #   Switch to Desktop 1=Meta+1
  #   Switch to Desktop 2=Meta+2
  #   Switch to Desktop 3=Meta+3
  #   Switch to Desktop 4=Meta+4
  #   Window Close=Meta+Q
  #   Window Maximize=Meta+Up
  #   Window Minimize=Meta+Down
  #   Window Quick Tile Left=Meta+Left
  #   Window Quick Tile Right=Meta+Right
  #   Expose=Meta+Tab
  #   Overview=Meta+W
  # '';

  # ── Input devices ──────────────────────────────────────────────
  # ~/.config/kcminputrc
  #
  # xdg.configFile."kcminputrc".text = ''
  #   [Keyboard]
  #   KeyboardRepeating=0
  #   NumLock=0
  #   RepeatDelay=500
  #   RepeatRate=40
  #
  #   [Mouse]
  #   XLibinputPointerAccelerationProfile=2
  #   XLbInptAccelProfileFlat=true
  #   cursorSize=
  #   cursorTheme=breeze_cursors
  # '';
}
