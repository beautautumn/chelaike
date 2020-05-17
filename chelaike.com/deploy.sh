#!/bin/sh

JEKYLL_ENV=production bundle exec jekyll build
rsync -rP --delete _site/ deploy@chelaike.com:www.chelaike.com
