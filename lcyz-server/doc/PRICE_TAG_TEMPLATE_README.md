# 车来客价签模板使用说明
======

__[默认模板](http://prime.oss-cn-hangzhou.aliyuncs.com/price_tag_templates/default.zip)可供参考__

## 目录结构
__请注意, 目录名必须相同__

```
.
├── css
├── images
├── js
└── index.html  (用户展示的价签页面)
```

__以默认模板的目录树为例__

```
.
├── css (css目录)
│   └── style.css
├── images (图片目录)
│   ├── bg_label_arrow.png
│   ├── bg_label_arrow2.png
│   ├── img_click_print.png
│   ├── star1.jpg
│   ├── star2.jpg
│   ├── star3.jpg
│   ├── star4.jpg
│   └── star5.jpg
├── index.html  (用户展示的价签页面)
└── js (js目录)
    ├── jquery.js
    └── switch.js
```

### 文件引用
__使用相对路劲引用文件, 比如 "./css/style.css" (格式严格)__


```
  <link rel="stylesheet" href="./css/style.css">
  <script src="./js/jquery.js"></script>
  <img src="./images/star.jpg" />
```

__css文件中 背景图片引用__

```
.on{ 
  background: url(../images/bg_label_arrow.png) no-repeat 0 center;
}

```


## 变量使用

__使用 {{ 变量名 }} 形式__

获取车辆里程

```
<span>{{car_mileage}}万公里</span>

```

## 基本的判断语法
__使用 {%  %} 标识判断__

```
{% if car_allowed_mortgage %}
  <p>
    (此车可按揭)
  </p>
{% endif %}
```

## 可用变量列表

```
车辆ID: car_id
商家名称: company_name
公司LOGO(返回url): company_logo
车辆名称: car_name
车辆星级: car_star_rating
车辆上牌日期: car_licensed_at
里程: car_mileage
排量: car_displacement
外观颜色: car_exterior_color
内饰颜色: car_interior_color
变速箱: car_transmission
二维码(返回url): car_qrcode
销售价: car_show_price_wan
完税价: car_new_car_final_price_wan
是否可以按揭: car_allowed_mortgage
按揭描述: car_mortgage_note
配置描述: car_configuration_note
出厂日期: car_manufactured_at
车身类型: car_type
卖点描述: car_selling_point
公司地址: car_street
联系电话: car_contact_mobile
车架号: car_vin
库存号: car_stock_number
交强险到期 car_compulsory_insurance_end_at
年审到期: car_annual_inspection_end_at
公司宣传语: car_slogan
```
