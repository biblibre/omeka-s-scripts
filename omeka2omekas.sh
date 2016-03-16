#!/usr/bin/env sh

PLUGIN_NAME=$1
CONFIGURABLE=$2
MODULE_DIR="$PLUGIN_NAME"
PLUGIN_PATH=/home/stl/htdocs/omeka/Omeka/plugins/$PLUGIN_NAME

mkdir modules/$MODULE_DIR
cd modules/$MODULE_DIR

mkdir asset
mkdir config
mkdir language
mkdir -p src/Controller
mkdir -p src/View/Helper
mkdir view

cp $PLUGIN_PATH/controllers/* src/Controller
cp $PLUGIN_PATH/languages/* language
cp -r $PLUGIN_PATH/libraries/$PluginName/* src
cp $PLUGIN_PATH/plugin.ini config/module.ini
cp $PLUGIN_PATH/${PLUGIN_NAME}Plugin.php Module.php
cp $PLUGIN_PATH/views/helpers/* src/View/Helper
cp -r $PLUGIN_PATH/views/* view
rm -rf view/helpers


sed -i '/\[info\]/d' config/module.ini 
sed -i -- 's/^link/module_link/' config/module.ini
sed -i  '/^name\|^version\|^author\|^configurable\|^description\|^module_link\|^author_link/!d' config/module.ini

if [ -n "$CONFIGURABLE" ]; then 
    echo 'configurable=true' >> config/module.ini
fi

sed -i "1 a namespace ${PLUGIN_NAME};\nuse Omeka\\\Module\\\AbstractModule;" Module.php

sed -i '/^class/c\class Module extends AbstractModule' Module.php
