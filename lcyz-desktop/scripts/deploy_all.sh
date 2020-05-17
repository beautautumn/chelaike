#!/bin/sh

for stage in staging chelaike hongsheng; do
  echo "\033[32mDeploying to ${stage}...\033[0m"
  STAGE=$stage npm run deploy
done
