{pkgs, ...}:
{
  imports = [];
  
  services.xserver.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    # theme
  };

  # Set Icon Avatar
  system.activationScripts.script.text = ''
    cp ${./rasmus.face.png} /var/lib/AccountsService/icons/rasmus
  '';

}
