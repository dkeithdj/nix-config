{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--no-default-browser-check"
      "--restore-last-sesion"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
    ];
  };
}
