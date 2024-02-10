{
  config,
  ...
}:
{
  # set icon
  # It cannot be read by sddm. 
  # I have copied the icon into /var/lib/AccountsService/icons/ as the name of the user "rasmus".
  # This is not optimal
  
  home.file.".face.icon".source = ./rasmus.face.png;
  home.file.".face".source = ./rasmus.face.png;
}

