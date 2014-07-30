#!/usr/bin/env bash
#Set up build environment for Dragino v2. Only need to run once on first compile. 

USAGE="Usage: . ./set_up_build_enviroment.sh /your/preferred/source/installation/path"

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

echo " "
echo " Get SECN 2 packages from GitHub repo"
git clone https://github.com/villagetelco/vt-secn2-packages vt-secn2-packages

echo " "
echo "*** Checkout the OpenWRT build environment to the path specified on the command line"
sleep 5
mkdir -p $OPENWRT_PATH
svn co svn://svn.openwrt.org/openwrt/tags/attitude_adjustment_12.09/ $OPENWRT_PATH

echo "*** Backup original feeds files if they exist"
sleep 2
mv $OPENWRT_PATH/feeds.conf.default  $OPENWRT_PATH/feeds.conf.default.bak

echo "*** Create new feeds.conf.default file"
echo "src-link  packages1209 $REPO_PATH/packages_12.09"      > $OPENWRT_PATH/feeds.conf.default
echo "src-link dragino2 $REPO_PATH/package" >> $OPENWRT_PATH/feeds.conf.default
echo "src-link secn2packages $REPO_PATH/vt-secn2-packages/packages-AA" >> $OPENWRT_PATH/feeds.conf.default

echo " "

echo "*** Update the feeds (See ./feeds-update.log)"
sleep 2
$OPENWRT_PATH/scripts/feeds update
sleep 2
echo " "

echo "*** Install OpenWrt packages"
sleep 10
$OPENWRT_PATH/scripts/feeds install -a
echo " "

echo ""
echo "copy Dragino2 Platform info"
rsync -avC platform/target/ $OPENWRT_PATH/target/

echo "copy extra $2 Platform info"
if [ $2 ]
then 
	APP=$2
	echo "copy extra $APP Platform info"
	rsync -avC platform-$APP/target/ $OPENWRT_PATH/target/		
fi

echo " "

#Remove tmp directory
rm -rf $OPENWRT_PATH/tmp/

echo "*** Change to build directory"
cd $OPENWRT_PATH
echo " "

echo "*** Run make defconfig to set up initial .config file (see ./defconfig.log)"
make defconfig > ./defconfig.log

# Backup the .config file
cp .config .config.orig
echo " "

echo "End of script"
