#!/usr/bin/env sh

set -e

PLUGIN_PATH=$1
CONFIGURABLE=$2
PLUGIN_NAME=$(basename "$PLUGIN_PATH")
MODULE_DIR="$PLUGIN_NAME"

mkdir modules/$MODULE_DIR
cd modules/$MODULE_DIR

copy_dir() {
	source=$1
	dest=$2
	options=$3

	if [ -e "$source" ]; then
		mkdir -p "$dest"
		cp $options $source/* "$dest"
	fi
}

mkdir config
cp "$PLUGIN_PATH/plugin.ini" "config/module.ini"
cp "$PLUGIN_PATH/${PLUGIN_NAME}Plugin.php" "Module.php"
copy_dir "$PLUGIN_PATH/controllers" "src/Controller"
copy_dir "$PLUGIN_PATH/languages" "language"
copy_dir "$PLUGIN_PATH/libraries/$PluginName" "src" "-r"
copy_dir "$PLUGIN_PATH/views/helpers" "src/View/Helper"
copy_dir "$PLUGIN_PATH/views" "view" "-r"
rm -rf "view/helpers"

sed -i '/\[info\]/d' config/module.ini 
sed -i -- 's/^link/module_link/' config/module.ini
sed -i  '/^name\|^version\|^author\|^configurable\|^description\|^module_link\|^author_link/!d' config/module.ini

if [ -n "$CONFIGURABLE" ]; then 
    echo 'configurable=true' >> config/module.ini
fi

sed -i "1 a namespace ${PLUGIN_NAME};\nuse Omeka\\\Module\\\AbstractModule;" Module.php

sed -i '/^class/c\class Module extends AbstractModule' Module.php
