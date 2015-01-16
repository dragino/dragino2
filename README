IoT Mesh -- A Generic OpenWrt Version with mesh, IoT, VoIP support for Dragino Devices
===============
This repository is a generic OpenWrt version from Dragino devices such as:
[MS14](http://www.dragino.com/products/mother-board.html), [HE](http://www.dragino.com/products/linux-module/item/87-he.html) and [Yun Shield](http://www.dragino.com/products/yunshield.html).

The user manual of this version can be found at [IoT Mesh Online Manual](http://wiki.dragino.com/index.php?title=IoT_Mesh_Firmware_User_Manual).

There is another Arduino Yun Alike firmware version. With the source in [this link](https://github.com/dragino/openwrt-yun)

Difference between these two firmware can be found [difference between IoT Mesh and Dragino Yun firmware](http://wiki.dragino.com/index.php?title=Firmware_and_Source_Code)

How to compile the image?
===============
``` bash
git clone https://github.com/dragino/dragino2.git dragino2-AA-IoT
cd dragino2-AA-IoT
./set_up_build_enviroment.sh ms14
./build_image.sh ms14
```

After complination, the images can be found on **dragino2-AA-IoT/image** folder. The folder includes:
*openwrt-ar71xx-generic-dragino2-kernel.bin  kernel files, for upgrade in u-boot
*openwrt-ar71xx-generic-dragino2-rootfs-squashfs.bin    rootfs file, for upgrade in u-boot
*openwrt-ar71xx-generic-dragino2-squashfs-sysupgrade.bin   sysupgrade file, used for web-ui upgrade
*md5sum  md5sum for above files
*custom_config Customized files and config for this build , as a back up

How to debug if build fails?
===============
``` bash
cd dragino2-AA-IoT/ms14
make V=s
```
Above commands will enable verbose and build in single thread to get a view of the error during build. 


Have Fun!

Dragino Technology
