#!/bin/bash

BRANCH=`git branch | grep '*'`

if [[ "$BRANCH" != "* develop" ]]; then
  echo "Must be launched from develop"
  exit
fi

VERSION=`git describe --abbrev=0`

VERSION_BITS=(${VERSION//./ })

VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}
VNUM3=$((VNUM3+1))

NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

echo "Releasing $NEW_TAG to master"

git checkout master

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git pull origin develop

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git push origin master

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git tag -a $NEW_TAG -m "$NEW_TAG"

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git push --tags

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git checkout develop

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi


echo "Release of $NEW_TAG OK"

VERSION_BITS=(${NEW_TAG//./ })

VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}
VNUM3=$((VNUM3+1))

NEXT_TAG="$VNUM1.$VNUM2.$VNUM3"


echo "Preparing next version: $NEXT_TAG"

sed -i -e "s/$NEW_TAG: Current version/$NEXT_TAG: Current version\\n\\n## __PLACEHOLDER__/g" README.md

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

sed -i -e "s/$NEW_TAG/$NEXT_TAG/g" README.md

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

sed -i -e "s/__PLACEHOLDER__/$NEW_TAG/g" README.md

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi


sed -i -e "s/$NEW_TAG/$NEXT_TAG/g" cli.go

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi


git commit -am "Preparing new tag $NEXT_TAG"

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

git push origin develop

if [[ "$?" != "0" ]]; then
  echo "Error"
  exit
fi

echo "Ok"