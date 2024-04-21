let
  sha256 = "sha256:021h79as3gjs9sh8p4r81naibrp5j4ngp6948v4djwl6jz9pxfw6";
  rev = "ae22f8403a6aa4cc1bd30a0dbfb014187810af4e";
in
builtins.trace "(Using pinned Nixpkgs at ${rev})"
import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})
