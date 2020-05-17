# Megatron

* 开发环境：http://megatron.lina.che3bao.com

## API

```javascript
    GET /api/v1/brands                                                     //获取所有品牌信息
    GET /api/v1/brands/?series[name]=xxx                                   //通过车系名获取品牌信息
    GET /api/v1/series/?brand[name]=xxx                                    //获取某品牌的所有车系
    GET /api/v1/styles/?series[name]=xxx                                   //获取某车系的所有车款
    GET /api/v1/styles/?series[name]=xxx&style[name]=xxx                   //获取某车款的详细数据
```

## 添加新车型

方法1: 

http://git.che3bao.com/autobots/Megatron/blob/master/lib/spy/additional.yml 在这个文件里加入需要添加的新车型

* 新的品牌，添加在`brands`下，需要的字段有：`name`，`first_letter`，`code`(随机数字串)。
* 新的车系，添加在`series`下，需要的字段有: `name`，`manufacturer`, `brand_code`(所属品牌code)，`code`(随机数字串)。
* 新的车款，添加在`styles`下，需要的字段有：`series_code`（所属车系code），`year`，`name`， `id`（随机数字串）。

添加完后，提交代码并部署，在服务器上执行命令`RAILS_ENV=environment rake spy:additional` 就添加成功了。

方法2:

直接在数据库里插入数据。