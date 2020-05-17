NODE_ENV=production ./node_modules/.bin/webpack --verbose --colors --display-error-details --config webpack/prod.config.js

cat << EOF >> dist/index.html
<!--
STAGE:      $STAGE
BRANCH:     `git name-rev --name-only HEAD`
REVISION:   `git rev-parse HEAD`
BUILD DATE: `date '+%Y-%m-%d %H:%M:%S'`
BUILD BY:   `whoami`
POWERED BY: Autobots
-->
EOF
