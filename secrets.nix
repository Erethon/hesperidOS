let
  warden = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUyNX5xAsGPVkm9Yb4mOg753BG8/rv0U2cga6zWkQW5";
in
{
  "secrets/hass-bearer.age".publicKeys = [ warden ];
}
