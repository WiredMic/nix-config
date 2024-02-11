{pkgs, ...}:
{
  imports = [];
 
  
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects   
  ];

  services.xserver.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    theme = "${import ./sddm-suger-dark.nix {inherit pkgs;}}";
  };

  # Set Icon Avatar
  system.activationScripts.script.text = ''
    cp ${./rasmus.face.png} /var/lib/AccountsService/icons/rasmus
  '';

}
