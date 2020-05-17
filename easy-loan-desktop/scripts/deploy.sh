#!/bin/sh

publish_to()
{
  rsync -rP --delete build/ $1
}

case "$STAGE" in
  staging)
    url=http://loan.lina-server.chelaike.com/
    dest=deploy@123.206.176.87:easy-loan-desktop/
    ;;
  production)
    url=http://loan.chelaike.com
    dest=deploy@115.159.125.108:easy-loan-desktop/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

publish_to $dest

echo "\033[32mDeploy finished.\033[0m"
echo "Visit: ${url}"
