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

rev=`git rev-parse --short HEAD`

case "$STAGE" in
  staging)
    project=prime-alliance-dashboard-staging
    url=http://alliance.lina.server.chelaike.com
    dest=deploy@lina.server.chelaike.com:prime-alliance-dashboard/
    ;;
  production)
    project=prime-alliance-dashboard
    url=http://lm.chelaike.com
    dest=deploy@lm.chelaike.com:prime-alliance-dashboard/
    ;;
  *)
    echo "$STAGE Didn't match anything"
esac

create_release $project $rev
upload_sourcemap $project $rev $url
remove_soucemap
set_release $rev
publish_to $dest
