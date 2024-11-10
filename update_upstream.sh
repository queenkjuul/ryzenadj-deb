#!/bin/bash

DEBEMAIL=queenkjuul@pm.me

CURRENT=$(./get_current_release.sh)
LATEST=$(./get_latest_release.sh)
SYNCED=1
ORIG=1
BUILD=1

if [ $CURRENT != $LATEST ]; then
  git checkout -b $LATEST
  cd ryzenadj-orig
  echo "checkout" && \
  git checkout upstream && \
  echo "fetch" && \
  git fetch && \
  echo "reset to v$LATEST" && \
  git reset --hard v$LATEST && \
  echo "stage" && \
  git add . && \
  echo "commit" && \
  git commit -m "Sync with upstream v$LATEST" # commit may return non-zero if we've already updated the branch but we may still want to push
  echo "push" && \
  git push origin && \
  SYNCED=0
fi

if [ 0 -eq $SYNCED ]; then
  echo "checkout master"
  git checkout master
  echo "create new branch"
  git checkout -b $LATEST
  echo "merge upstream"
  git merge upstream --no-edit && \
  git push -u origin $LATEST
  cd ..
  echo "cleaning"
  ./clean_built_source_files.sh
  mv ryzenadj_$CURRENT.orig.tar.xz ryzenadj_$CURRENT.orig.tar.xz.old
  echo "orig" && cd ryzenadj-orig && rm debian/files && touch debian/files &&
  dh_make -sy --createorig -c gpl3 -p ryzenadj_$LATEST
  cd ..
fi

if [ -f ryzenadj_$LATEST.orig.tar.xz ]; then
  ORIG=0 && rm *.old
fi

if [ 0 -eq $ORIG ]; then
  cd ryzenadj-orig
  echo "change"
  DEBEMAIL=queenkjuul@pm.me debchange -D oracular -u low -M -v $LATEST-qkj3ubuntu1 -U "Sync with upstream version $LATEST" && \
  echo "build" && debuild -S -k$DEBEMAIL -I && BUILD=0
fi

if [ 0 -eq $BUILD ]; then
  cd ..
  dput ppa:queenkjuul/ryzen-tools *_source.changes
  git add .
  git commit -m "Built new upstream $LATEST"
  git push -u origin $LATEST
fi