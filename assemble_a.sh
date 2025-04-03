#!/usr/bin/env zsh

flutter clean

rm -rf android/.gradle android/.idea android/build

# shellcheck disable=SC2164
cd android

./gradlew clean

# shellcheck disable=SC2103
cd ..

flutter pub get

# shellcheck disable=SC2129
export "FLUTTER_ROOT=/Users/dimakulahyn/development/flutter" &&
export "FLUTTER_APPLICATION_PATH=/Users/dimakulahyn/StudioProjects/split_trip" &&
export "COCOAPODS_PARALLEL_CODE_SIGN=true" &&
export "FLUTTER_TARGET=/Users/dimakulahyn/StudioProjects/split_trip/lib/main.dart" &&
export "FLUTTER_BUILD_DIR=build" &&
export "FLUTTER_BUILD_NAME=1.0.0" &&
export "FLUTTER_BUILD_NUMBER=1" &&
export "DART_OBFUSCATION=false" &&
export "TRACK_WIDGET_CREATION=true" &&
export "TREE_SHAKE_ICONS=false" &&
export "PACKAGE_CONFIG=/Users/dimakulahyn/StudioProjects/split_trip/.dart_tool/package_config.json"
