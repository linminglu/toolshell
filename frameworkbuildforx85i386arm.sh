#!/bin/bash
#build ijkmediaframework

TARGET_PUBLISH="IJKMediaFramework"
PJ_NAME="IJKMediaPlayer"
EXECUTABLE_PATH="${TARGET_PUBLISH}"
PROJECT_PUBLISH_NAME="${TARGET_PUBLISH}.framework"
CURRENT_DIR_PATH=`pwd`
BUILD_DIR_PATH=${CURRENT_DIR_PATH}/build
PROJECT_ACTION=build
if [[ "$1" = "silence" ]]
then
    PROJECT_LOGGER='/dev/null'
else
    PROJECT_LOGGER='/dev/stdout'
fi
echo ${PJ_NAME}


echo "build i386 arch..."

PROJECT_SDK_VERSION=`xcrun --show-sdk-platform-version --sdk iphonesimulator`
PROJECT_SDK_ROOT=`xcrun --show-sdk-platform-path --sdk iphonesimulator`
PROJECT_CONFIGURATION_BUILDTYPE="Debug"

xcodebuild -project ${CURRENT_DIR_PATH}/${PJ_NAME}.xcodeproj  ENABLE_BITCODE=NO -sdk "iphonesimulator${PROJECT_SDK_VERSION}" -configuration "${PROJECT_CONFIGURATION_BUILDTYPE}" -target "IJKMediaFramework" BUILD_DIR="${BUILD_DIR_PATH}" BUILD_ROOT="${BUILD_DIR_PATH}" SYMROOT="${BUILD_DIR_PATH}"  -arch x86_64 build > $PROJECT_LOGGER
#xcodebuild -project ${CURRENT_DIR_PATH}/UOneMedia.xcodeproj ENABLE_BITCODE=YES -sdk "iphonesimulator${PROJECT_SDK_VERSION}" -configuration "${PROJECT_CONFIGURATION_BUILDTYPE}" -target "UOneMediaStaticLib" BUILD_DIR="${BUILD_DIR_PATH}" BUILD_ROOT="${BUILD_DIR_PATH}" SYMROOT="${BUILD_DIR_PATH}" -arch i386 build > $PROJECT_LOGGER
echo "cp the i386 to root path"

/bin/cp -a  "${BUILD_DIR_PATH}/Debug-iphonesimulator/${PROJECT_PUBLISH_NAME}/${EXECUTABLE_PATH}"  "${BUILD_DIR_PATH}/"

echo "build x86_64 arch..."
xcodebuild -project ${CURRENT_DIR_PATH}/${PJ_NAME}.xcodeproj  ENABLE_BITCODE=NO -sdk "iphonesimulator${PROJECT_SDK_VERSION}" -configuration "${PROJECT_CONFIGURATION_BUILDTYPE}" -target "IJKMediaFramework" BUILD_DIR="${BUILD_DIR_PATH}" BUILD_ROOT="${BUILD_DIR_PATH}" SYMROOT="${BUILD_DIR_PATH}" -arch i386 build > $PROJECT_LOGGER



echo "build arm7 / arm64 arch..."

PROJECT_SDK_VERSION=`xcrun --show-sdk-platform-version --sdk iphoneos`
PROJECT_SDK_ROOT=`xcrun --show-sdk-platform-path --sdk iphoneos`
PROJECT_CONFIGURATION_BUILDTYPE="Release"

#xcodebuild -project ${CURRENT_DIR_PATH}/UOneMedia.xcodeproj ENABLE_BITCODE=YES -sdk "iphoneos${PROJECT_SDK_VERSION}" -configuration "${PROJECT_CONFIGURATION_BUILDTYPE}" -target "UOneMediaStaticLib" BUILD_DIR="${BUILD_DIR_PATH}" BUILD_ROOT="${BUILD_DIR_PATH}" SYMROOT="${BUILD_DIR_PATH}" -arch arm64 build > $PROJECT_LOGGER
xcodebuild -project ${CURRENT_DIR_PATH}/"${PJ_NAME}".xcodeproj ENABLE_BITCODE=YES -sdk "iphoneos${PROJECT_SDK_VERSION}" -configuration "${PROJECT_CONFIGURATION_BUILDTYPE}" -target "IJKMediaFramework" BUILD_DIR="${BUILD_DIR_PATH}" BUILD_ROOT="${BUILD_DIR_PATH}" SYMROOT="${BUILD_DIR_PATH}" -arch armv7 -arch arm64  build > $PROJECT_LOGGER

echo "merge x86 / x86_64 / armv7 /arm64 arch static lib together .. "

lipo -create "${BUILD_DIR_PATH}/Debug-iphonesimulator/${PROJECT_PUBLISH_NAME}/${EXECUTABLE_PATH}" "${BUILD_DIR_PATH}/${EXECUTABLE_PATH}" "${BUILD_DIR_PATH}/Release-iphoneos/${PROJECT_PUBLISH_NAME}/${EXECUTABLE_PATH}" -output "${BUILD_DIR_PATH}/${EXECUTABLE_PATH}"

echo "deploy ${PROJECT_PUBLISH_NAME}"
mkdir -p "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/Versions/A/Headers"
/bin/cp -a "${BUILD_DIR_PATH}/Release-iphoneos/${PROJECT_PUBLISH_NAME}/Headers" "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/Versions/A/"
/bin/cp -a "${BUILD_DIR_PATH}/${EXECUTABLE_PATH}" "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/Versions/A/${TARGET_PUBLISH}"

pushd "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/Versions" > $PROJECT_LOGGER
/bin/ln -sfh "A" "Current"
/bin/ln -sfh "Versions/Current/Headers" "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/Headers"
/bin/ln -sfh "Versions/Current/${TARGET_PUBLISH}" "${CURRENT_DIR_PATH}/${PROJECT_PUBLISH_NAME}/${TARGET_PUBLISH}"
popd > $PROJECT_LOGGER

echo "install ${TARGET_PUBLISH}.bundle"
/bin/cp -a "${BUILD_DIR_PATH}/Release-iphoneos/${TARGET_PUBLISH}.bundle" "${CURRENT_DIR_PATH}"

