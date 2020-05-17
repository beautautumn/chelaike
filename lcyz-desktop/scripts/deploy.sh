#!/bin/sh

publish_to()
{
  rsync -rP --delete dist/ $1
}

remove_soucemap()
{
  find dist -name '*.map' -exec rm {} \;
}

set_release() {
  perl -pi -e "s/{release}/$1/" dist/index.html
}

rev=`git describe --tags`

case "$STAGE" in
  production)
    project=prime-desktop
    url=http://bm_desktop.chelaike.cn
    dest=deploy@120.26.74.148:bm-desktop/
    ;;
  xuangeche)
    project=prime-desktop
    url=http://xgc_desktop.chelaike.cn
    dest=deploy@120.26.74.148:xgc-desktop/
    ;;
  lcyz)
    project=prime-desktop
    url=http://desktop.lcyzauto.com
    dest=deploy@47.96.25.227:prime-desktop/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

remove_soucemap
set_release $rev
publish_to $dest

echo "\033[32mDeploy finished.\033[0m"
echo "Visit: ${url}"
