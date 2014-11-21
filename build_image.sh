#!/usr/bin/env bash
#Build Image for Dragino2.  

USAGE="Usage: . ./build_image.sh /source/installation/path application"

if (( $# < 1 ))
then
	echo "Error. Not enough arguments."
	echo $USAGE
	exit 1
elif (( $# > 2 ))
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
APP=IoT
if [ $2 ]
then 
APP=$2
fi

VERSION=1.3.1
BUILD=$APP-$VERSION
BUILD_TIME="`date`"

#########################
echo ''
echo "Start build process for application $APP"
echo ''
###########################

#echo "#remove tmp directory"
#rm -rf $OPENWRT_PATH/tmp/

echo ""
echo "Remove custom files from last build"
rm -rf $OPENWRT_PATH/files

echo ""
echo "Copy config and files"
echo ""
cp .config.$APP $OPENWRT_PATH/.config
cp -r files-$APP $OPENWRT_PATH/files

echo ""
echo "Entering build directory"
cd $OPENWRT_PATH
echo ""

echo ""
echo "Update version and build date"
sed -i "s/VERSION/$BUILD/g" files/etc/banner
sed -i "s/TIME/$BUILD_TIME/g" files/etc/banner
echo ""


echo ""
echo "Activate draigno config as default config"
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
mkdir $REPO_PATH/image/$APP-build--v$VERSION--$DATE
IMAGE_DIR=$REPO_PATH/image/$APP-build--v$VERSION--$DATE

echo  "Move files to ./image folder"
mv ./bin/ar71xx/openwrt*kernel.bin     $IMAGE_DIR/
mv ./bin/ar71xx/openwrt*squashfs.bin   $IMAGE_DIR/
mv ./bin/ar71xx/openwrt*sysupgrade.bin $IMAGE_DIR/

echo "Update md5sums"
cat ./bin/ar71xx/md5sums | grep "dragino2" >> $IMAGE_DIR/md5sums


echo ""
echo "Back Up Custom Config to Image DIR"
echo ""
mkdir $IMAGE_DIR/custom_config
cp $REPO_PATH/.config.$APP $IMAGE_DIR/custom_config/.config
cp -r $REPO_PATH/files-$APP $IMAGE_DIR/custom_config/files


echo ""
echo "End Dragino2 build"
echo ""

##################
