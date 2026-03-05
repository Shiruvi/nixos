{
  system.userActivationScripts = {
    copy-fonts-local-share = {
      text = ''
        if [ -d "~/.icons/dracula-icons" ]; then
        else
          git clone https://github.com/m4thewz/dracula-icons ~/.icons/dracula-icons
      '';
    };
  };
}
