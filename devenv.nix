{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # NOTE:
  # https://devenv.sh/containers/

  # https://devenv.sh/packages/
  packages = with pkgs; [
    python312Packages.isort
    python312Packages.black
    python312Packages.ruff
    python312Packages.reuse

    python312Packages.playwright

    nodejs
    playwright
    playwright-driver
    firefox
  ];

  # TODO: example of overlays, need to add browserforge python package from my own git repo
  overlays = [ ];

  # https://devenv.sh/languages/
  languages.nix.enable = true;
  languages.nix.lsp.package = pkgs.nil;

  # https://devenv.sh/supported-languages/python/
  languages.python = {
    enable = true;
    package = pkgs.python312;
    manylinux.enable = true;
    uv = {
      enable = true;
      package = pkgs.uv;
      sync.enable = true;
    };
  };

  env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    pkgs.zlib
    pkgs.glib
    pkgs.libuv
    pkgs.xorg.libX11
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXdamage
    pkgs.xorg.libXext
    pkgs.xorg.libXfixes
    pkgs.xorg.libXrandr
    pkgs.alsa-lib
    pkgs.nspr
    pkgs.nss
    pkgs.cups
    pkgs.dbus
    pkgs.expat
    pkgs.atk
    pkgs.at-spi2-atk
    pkgs.cairo
    pkgs.pango
    pkgs.gtk3
  ];

  # https://devenv.sh/basics/
  env.FIREFOX_PATH = "${pkgs.firefox}/bin/firefox";
  env.PLAYWRIGHT_PYTHON_PATH = "${pkgs.python312}/bin/python3";
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  env.PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
  env.PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;

  enterShell = ''
    # unset PYTHONPATH

    export UV_LINK_MODE=copy
    export UV_NO_SYNC=1
    export UV_PYTHON_DOWNLOADS=never
    export UV_PYTHON_PREFERENCE=system
    export REPO_ROOT=$(git rev-parse --show-toplevel)

    # . .devenv/state/venv/bin/activate
  '';

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  # enterShell = ''
  #   hello
  #   git --version
  # '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
