#!/usr/bin/env bash
#Build Image for Dragino2.  

USAGE="Usage: . ./build_image.sh /source/installation/path"

if (( $# < 1 ))
then
	echo "Error. Not enough arguments."
	echo $USAGE
	exit 1
elif (( $# > 1 ))
then
	echo "Error. Too many arguments."
	echo $USAGE
	exit 2
elif [ $1 == "--help" ]
then
	echo $USAGE
	exit 3
fi

REPO_PATH=$(pwd)
OPENWRT_PATH=$1

#########################

echo "Start build process"

###########################

#echo "#remove tmp directory"
#rm -rf $OPENWRT_PATH/tmp/

echo ""
echo "Remove custom files from last build"
rm -rf $OPENWRT_PATH/files

echo ""
echo "Copy dragino config and files"
echo ""
cp .config $OPENWRT_PATH/.config
cp -r files-IoT $OPENWRT_PATH/files

echo ""
echo "Activate draigno config as default config"
cd $OPENWRT_PATH
echo " Run defconfig"
make defconfig > /dev/null

echo ""
echo "Run make for ms14"
make -j8 V=99

echo "Copy Image"
if [ ! -d $REPO_PATH/image ]
then
mkdir $REPO_PATH/image
fi

echo "Set up new directory name with date"
DATE=`date +%Y%m%d-%H%M`
mkdir $REPO_PATH/image/build-$DATE

echo  "Move files to ./image folder"
mv ./bin/ar71xx/openwrt*kernel.bin     $REPO_PATH/image/build-$DATE/
mv ./bin/ar71xx/openwrt*squashfs.bin   $REPO_PATH/image/build-$DATE/
mv ./bin/ar71xx/openwrt*sysupgrade.bin $REPO_PATH/image/build-$DATE/

echo "Update md5sums"
cat ./bin/ar71xx/md5sums | grep "dragino2" >> $REPO_PATH/image/build-$DATE/md5sums
echo ""
echo "End Dragino2 build"
echo ""

##################
