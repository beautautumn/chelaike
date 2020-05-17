#!/bin/sh

publish_to()
{
  rsync -rP --delete dist/ $1
}

rev=`git describe --tags`

case "$STAGE" in
  staging)
    project=prime-desktop-market
    url=http://market-crm.chelaike.com
    dest=deploy@120.26.74.148:prime-desktop-market/
    ;;
  production)
    project=prime-desktop-market
    url=http://market-crm.chelaike.com
    dest=deploy@120.26.74.148:prime-desktop-market/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

publish_to $dest

echo "\033[32mDeploy finished.\033[0m"
echo "Visit: ${url}"
