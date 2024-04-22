{ lib
, runCommand
, firmwareLinuxNonfree
}:

# The minimum set of firmware files required for the family
runCommand "msm8916-firmware" {
  src = firmwareLinuxNonfree;
  meta.license = firmwareLinuxNonfree.meta.license;
} ''
  [ -d $out/lib/firmware/qcom ] || mkdir -p $out/lib/firmware/qcom
  cp -vf $src/lib/firmware/qcom/{a300_pfp.fw,a300_pm4.fw} $out/lib/firmware/qcom
''
