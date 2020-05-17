#!/bin/sh

publish_to()
{
  rsync -rP --delete dist/ $1
}

rev=`git describe --tags`

case "$STAGE" in
  staging)
    project=qiyuan-prime-desktop
    url=http://desktop.qiyuan.chelaike.com
    dest=deploy@59.110.153.40:qiyuan-prime-desktop/
    ;;
  production)
    project=qiyuan-prime-desktop
    url=http://desktop.qiyuan.chelaike.com
    dest=deploy@59.110.153.40:qiyuan-prime-desktop/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

publish_to $dest

echo "\033[32mDeploy finished.\033[0m"
echo "Visit: ${url}"
