{ config, lib, pkgs, ... }:

# Based in part on device-samsung-serranove from pmbootstrap

# REVIEW(Krey): Please advice on how to handle these firmware requirements:
# * Requires a firmware for GPU/WiFi/BT/Modem/Video
# ** msm-firmware-loader -- https://gitlab.com/postmarketOS/pmaports/-/tree/master/main/msm-firmware-loader -- Unsure what this is
# ** firmware-samsung-serranove-wcnss-nv -- https://gitlab.com/postmarketOS/pmaports/-/blob/master/device/community/firmware-samsung-serranove/APKBUILD -- WiFi firmware
# ** qhypstub -- https://github.com/msm8916-mainline/qhypstub maybe? (not used in pmos)

### !!! WARNING SECURITY !!! ### - DO NOT MERGE WITHOUT VERIFICATION
### !!! WARNING SECURITY !!! ### - DO NOT MERGE WITHOUT VERIFICATION
### !!! WARNING SECURITY !!! ### - DO NOT MERGE WITHOUT VERIFICATION
# * CVE-2022-22063 -- https://github.com/msm8916-mainline/CVE-2022-22063

{
  imports = [
    ../families/msm8916-mainline
  ];

  mobile.device.name = "samsung-serranove";
  mobile.device.identity = {
    name = "Galaxy S4 Mini Value Edition";
    manufacturer = "Samsung";
  };

  mobile.device.supportLevel = "best-effort";

  # The hardware supports aarch64-*, but the firmware was never updated from armv7 -> Disfunctional GPU/WiFi/BT/Modem/Video on aarch64-*
  mobile.system.system = "armv7l-linux";

  mobile.hardware = {
    ram = 1024 * 1.5;
    screen = {
      width = 540; height = 960;
    };
  };

  # Pending contribution: https://github.com/msm8916-mainline/linux/pull/354 -> Remove after
  mobile.system.android.appendDTB = [
    "dtbs/qcom-msm8916-${config.mobile.device.name}.dtb"
  ];

  boot.kernelParams = lib.mkAfter [
    "reflect_x" # Due to hardware bug with the display wired backwards we need to do reflect_x (https://gitlab.com/postmarketOS/pmaports/-/issues/1340)
  ];

  # mobile.device.firmware = pkgs.callPackage ./firmware {};
  # mobile.boot.stage-1.firmware = [
  #   config.mobile.device.firmware
  # ];

  mobile.boot.stage-1.kernel.modules = [
    "panel-samsung-s6e88a0-ams427ap24"
  ];

  # To manage: skip copying recovery image avb footer (recovery partition size: 15728640, recovery image size: 15820800).
  mobile.boot.stage-1.compression = "xz";

  mobile.kernel.structuredConfig = [
    (helpers: with helpers; {
      CC_OPTIMIZE_FOR_PERFORMANCE = no;
      CC_OPTIMIZE_FOR_SIZE = yes;
    })
  ];
}
