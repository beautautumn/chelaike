# 车商官网前后台

## 多租户

采用顶级域名/二级域名来区分租户, 开发时可以采用写入 `/etc/hosts` 的办法来测试
例如:

```
127.0.0.1 chuche.site
127.0.0.1 www.chuche.site
127.0.0.1 www.tianche.site
127.0.0.1 tianche.site
127.0.0.1 sites.dev
127.0.0.1 tianche.sites.dev
127.0.0.1 chuche.sites.dev
127.0.0.1 www.404.site
127.0.0.1 404.sites.dev
```

`db/seeds.rb` 中有 `天车` 和 `楚车` 的记录, 访问`www.tianche.site:3000/`会找到相应的租户, 否则就跳转到 404 (或者某个默认页面?)
