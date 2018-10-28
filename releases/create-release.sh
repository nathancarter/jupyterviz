#!/bin/sh

#
# A Unix shell script to tar-and-gz the latest version of this package,
# placing the result in releases/downloads/.
#

echo "Starting..."

myPkgName="jupyterviz"

echo "Creating release for package $myPkgName..."

pkgInfoCode="Filename(DirectoriesPackageLibrary(\"$myPkgName\",\"\")[1],\"PackageInfo.g\")"

echo "Asking GAP where the package is located..."

myPkgDir=`gap -b -q <<EOF
Print($pkgInfoCode);
EOF
`
myPkgDir="${myPkgDir#"${myPkgDir%%[![:space:]]*}"}"  # rm trailing spaces
myPkgDir="${myPkgDir%"${myPkgDir##*[![:space:]]}"}"  # rm leading spaces
myPkgDir=$(dirname "${myPkgDir}")

echo "Found package here: $myPkgDir"
echo "Asking GAP for latest package version..."

myPkgVersion=`gap -b -q <<EOF
Print(InstalledPackageVersion("$myPkgName"));
EOF
`
myPkgVersion="${myPkgVersion#"${myPkgVersion%%[![:space:]]*}"}"  # rm trailing spaces
myPkgVersion="${myPkgVersion%"${myPkgVersion##*[![:space:]]}"}"  # rm leading spaces

echo "Found this version: $myPkgVersion"
echo "Switching to this directory: $myPkgDir/../"

cd "$myPkgDir/.."

echo "Archiving folder $myPkgName/ into its releases/downloads/ folder..."

tar -cvzf "$myPkgName/releases/downloads/$myPkgName-$myPkgVersion.tar.gz" \
    --exclude .git --exclude releases/downloads --exclude gh-pages \
    "$myPkgName"

echo "Done."
