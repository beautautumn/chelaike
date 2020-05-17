#!/bin/sh

for stage in staging production; do
  echo "\033[32mDeploying to ${stage}...\033[0m"
  STAGE=$stage npm run deploy
done
