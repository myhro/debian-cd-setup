#!/bin/bash

lastarch=m68k

SETUP_DIR=$(dirname $0)

cd $SETUP_DIR

. images4testing_d-i

for arch in i386 powerpc alpha amd64 arm hppa ia64 mips mipsel s390 sparc $lastarch
do
  date
  time DI_DIST="$DI_DIST" ./testingcds "$arch"
  if [ "$arch" != "$lastarch" ] ; then
     rsync -rHltvz --delete "/org/cdimage.debian.org/www/testing/cd/jigdo-area/$arch" manty@cdimage.debian.org:cdimage-testing/cd/jigdo-area/ &
  fi
done

killall rsync

mkdir -p /org/cdimage.debian.org/www/testing/cd/trace/
HOST=`hostname -f`
date -u > "/org/cdimage.debian.org/www/testing/cd/trace/$HOST"

rsync -rHltvz --delete "/org/cdimage.debian.org/www/testing/cd/jigdo-area/$lastarch" manty@cdimage.debian.org:cdimage-testing/cd/jigdo-area/

# Finally do a global cd sync without deleting anything and trace at cdimage
rsync -rHltvz /org/cdimage.debian.org/www/testing/cd/ manty@cdimage.debian.org:cdimage-testing/cd/
ssh cdimage.debian.org /home/manty/bin/traceweeklycds
