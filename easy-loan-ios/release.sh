#!/bin/sh

release()
{
  echo "===========清理垃圾============"
  rm -f $1.ipa
  echo "===========开始编译============"
  fastlane gym --scheme $1 --clean --output_name $1.ipa --export_method enterprise --silent
  echo "===========上传文件============"
  curl -F "file=@./$1.ipa" -F "uKey=540573e1fae7d49f1f25487cda2b1227" -F "_api_key=3f3a7866e70155d30df1b78b1e54dadb" https://qiniu-storage.pgyer.com/apiv1/app/upload
  echo "===========发布成功============"
}

case "$1" in
  staging)
    release EasyLoanTest
    ;;
  production)
    release EasyLoan
    ;;
  *)
    echo "$1 Didn't match anything"
esac