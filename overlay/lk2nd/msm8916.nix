{
  stdenv
, fetchFromGitHub
, fetchpatch
, dtc
, gcc-arm-embedded
, python3
}:
let
  python = (python3.withPackages (p: [
    p.libfdt
  ]));

in stdenv.mkDerivation {
  pname = "lk2nd";
  version = "0.15.0-msm8916-3c9739a";

  src = fetchFromGitHub {
    repo = "lk2nd";
    owner = "msm8916-mainline";
    rev = "0.15.0";
    # DO_NOT_MERGE(Krey): Adjust this
    hash = "sha256-000000000000000000000000000000000000000000000";
  };

  nativeBuildInputs = [
    gcc-arm-embedded
    dtc
    python
  ];

  patches = [];

  postPatch = ''
    patchShebangs --build scripts/{dtbTool,mkbootimg}
  '';

  LD_LIBRARY_PATH = "${python}/lib";

  installPhase = ''
    mkdir -p $out/
    cp ./build-lk2nd-msm8916/lk2nd.img $out
  '';

  makeFlags = [
    "lk2nd-msm8916"
    "LD=arm-none-eabi-ld"
    "TOOLCHAIN_PREFIX=arm-none-eabi-"
  ];

}
