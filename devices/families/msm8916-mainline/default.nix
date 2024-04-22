{ config, lib, pkgs, ... }:

{
  imports = [
    ./sound.nix
  ];

  mobile.hardware = {
    soc = "qualcomm-msm8916";
  };

  mobile.boot.stage-1.kernel = {
    package = (pkgs.callPackage ./kernel { });
    modular = true; # REVIEW(Krey): Unsure..
    modules = [
      "msm" # DRM Module
      "zinitix"
      "rt5033"
      "rt5033-charger"
    ];
  };

  # mobile.boot.serialConsole = "ttyMSM0,115200";

  hardware.enableRedistributableFirmware = true;

  mobile.system.type = "android";
  mobile.system.android = {
    bootimg.flash = {
      offset_base = "0x80000000";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0x02000000";
      offset_second = "0x00f00000";
      offset_tags = "0x01e00000";
      pagesize = "2048";
    };
    appendDTB = lib.mkDefault [
      "dtbs/msm8916-${config.mobile.device.name}.dtb"
    ];
  };

  mobile.system.android.flashingMethod = "lk2nd";

  mobile.usb = {
    mode = "gadgetfs";
    idVendor = "0x04e8"; # Samsung Electronics Co., Ltd
    idProduct = "6860"; # something not "D001", to distinguish nixos from fastboot/lk2nd

    # REVIEW(Krey): Unsure..
    gadgetfs.functions = {
      rndis = "rndis.usb0";
      adb = "ffs.adb";
    };
  };

  mobile.device.firmware = pkgs.callPackage ./firmware {};
  mobile.boot.stage-1.firmware = [
    config.mobile.device.firmware
  ];
}
