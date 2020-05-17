#!/bin/sh

SENTRY_SERVER=http://sentry.chelaike.com
SENTRY_API_KEY=aa136ea3cdfe47e083e580689cfe04eaf69524291b174eb0aa92d86fcd2da5ec

publish_to()
{
  rsync -rP --delete dist/ $1
}

create_release()
{
  curl -X "POST" "$SENTRY_SERVER/api/0/projects/tianche/$1/releases/" \
    -H "Authorization: Bearer $SENTRY_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"version\":\"$2\"}"
}

upload_sourcemap()
{
  mapFile=`ls dist | grep js.map`

  curl -X "POST" "$SENTRY_SERVER/api/0/projects/tianche/$1/releases/$2/files/" \
    -H "Authorization: Bearer $SENTRY_API_KEY" \
    -H "Content-Type: multipart/form-data; boundary=__X_PAW_BOUNDARY__" \
    -F "name=$3/$mapFile" \
    -F "file=@dist/$mapFile"
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
  staging)
    project=prime-desktop-staging
    branch=`git name-rev --name-only HEAD`
    if [ $branch == "master" ] || [ $branch == "develop" ] || [ `echo $branch | grep "^release/"` ]; then
      url=http://pc.lina-server.chelaike.com
      dest=deploy@123.206.176.87:prime-desktop/
    else
      url=http://${branch}.pc.lina-server.chelaike.com
      dest=deploy@123.206.176.87:prime-desktop-multibranch/${branch}/
    fi
    ;;
  chelaike)
    project=prime-desktop
    url=http://pc.prerelease.chelaike.com
    dest=deploy@115.159.125.108:prime-desktop-prerelease/
    ;;
  hongsheng)
    project=prime-desktop
    url=http://hspc.chelaike.com
    dest=deploy@120.26.74.148:prime-desktop-hongsheng/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

create_release $project $rev
upload_sourcemap $project $rev $url
remove_soucemap
set_release $rev
publish_to $dest

echo "\033[32mDeploy finished.\033[0m"
echo "Visit: ${url}"
