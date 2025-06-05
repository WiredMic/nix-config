{ config, lib, pkgs, ... }:

{

  options = {
    my.mime.enable = lib.mkEnableOption "enables my extentiens to work";
  };

  config = lib.mkIf config.my.mime.enable {
    # xdg.mimeApps.enable = false;

    # home.xdg.dataFile."mime/application/ltspice.xml".text = ''
    #   <?xml version="1.0" encoding="utf-8"?>
    #   <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    #   <mime-type type="application/vnd.jgraph.mxfile">
    #     <glob pattern="*.asc"/>
    #       <comment>LTSpice file</comment>
    #     <icon="/home/rasmus/.var/app/com.usebottles.bottles/data/bottles/bottles/LTspice/icons/LTspice.png" />
    #   </mime-type>
    #   </mime-info>
    # '';
  };
}
