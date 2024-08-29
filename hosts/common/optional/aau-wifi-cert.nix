{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = {
    my.aau-wifi-cert.enable =
      lib.mkEnableOption "Enables the wifi certificate for AAU wifi";
  };

  config = lib.mkIf config.my.aau-wifi-cert.enable {

    security.pki.certificates = [''
      AAU WIFI
      =========
      -----BEGIN CERTIFICATE-----
      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
      rWcUoB93tFHnRot78mZ16syqbA==
      -----END CERTIFICATE-----
    ''];

  };
}
