#!/bin/sh
# Bump the version in multiple files such as CMakeLists.txt, AndroidManifest.xml
# If option "-r <date>" is set, it will also update org.liri.liri.appdata.xml file.
# If option "-c" is set, it will also regenerate the fastlane changelogs from the NEWS file.
# There is no check at all if the release already exists or if the values are correct.
#
# SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

function usage() {
    echo "Usage: ./tools/bump_version.sh -v <version> [-r <date>] [-h]"
    echo "  -v, --version <version>   contains the new version <major>.<minor>.<patch>"
    echo "  -r, --release <date>      contains the date of the release YYYY-MM-DD (optional)"
    echo "  -c, --changelog           generate fastlane changelog from NEWS (optional)"
    echo "  -h, --help                displays this help"
}

if [ ! -f org.liri.liri.appdata.xml ]
then
    echo "ERROR: Run me from the top level source dir"
    exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--version)
      VERSION="$2"
      shift # past argument
      shift # past value
      ;;
    -r|--release)
      DATE="$2"
      shift # past argument
      shift # past value
      ;;
    -c|--changelog)
      CHANGELOG="1"
      shift # past argument
      ;;
    -h|--help)
        usage;
        exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

if [[ ! "${VERSION}" ]]
then
    echo "Mission version"
    usage
    exit 1
fi

major=`echo $VERSION | cut -d. -f1`
minor=`echo $VERSION | cut -d. -f2`
patch=`echo $VERSION | cut -d. -f3`

version=${major}.${minor}.${patch}
echo "Version  = $version"
echo "Date     = ${DATE}"

# Update CMakeLists LIRI_VERSION_MAJOR and LIRI_VERSION_MINOR variables
sed -i "s/set(LIRI_VERSION_MAJOR [0-9]\+)$/set\(LIRI_VERSION_MAJOR $major\)/" CMakeLists.txt
sed -i "s/set(LIRI_VERSION_MINOR [0-9]\+)$/set\(LIRI_VERSION_MINOR $minor\)/" CMakeLists.txt
sed -i "s/set(LIRI_VERSION_PATCH [0-9]\+)$/set\(LIRI_VERSION_PATCH $patch\)/" CMakeLists.txt

# Update AndroidManifest.xml
versioncode=$((${major}*10000 + ${minor}*100 + ${patch}))
sed -i "s/android:versionCode=\"[0-9]\+\"$/android:versionCode=\"$versioncode\"/" android/app/src/main/AndroidManifest.xml
sed -i "s/android:versionName=\"[0-9.]\+\"$/android:versionName=\"$version\"/" android/app/src/main/AndroidManifest.xml

git add CMakeLists.txt android/app/src/main/AndroidManifest.xml && git commit -m "bump version to ${major}.${minor}.${patch}"

if [[ "${DATE}" ]]
then
    # Add a new release in org.liri.liri.appdata.xml with the new date and release
    sed -i -e "/<releases>/a\ \ \ \ <release version=\"${major}.${minor}.${patch}\" date=\"$DATE\"/>" org.liri.liri.appdata.xml
    git add org.liri.liri.appdata.xml && git commit -m "appdata, add ${major}.${minor}.${patch} release"
fi

# TODO
if [[ "${CHANGELOG}" ]]
then
    #python tools/fdroid_update_fastlane_metadata.py
    echo "todo"
fi
