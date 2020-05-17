# 租户 tenants
tianche = Tenant.find_or_create_by(
  name: "天车", subdomain: "tianche", tld: "tianche.site",
  company_id: 167, phone: "13911112222"
)

# wechat_apps 微信公众号
default_wechat_app = WechatApp.find_or_create_by(
  tenant_id: tianche.id,
  app_id: "wxbe6ec1b410f661f2",
  user_name: "gh_ef19d7012987",
  refresh_token: "refreshtoken@@@2fEeoElWSysp_Vr_rlgRd9_7rpv5-pxLOA2ISZUK3C4",
  authorities: "{4,2,3,9}",
  nick_name: "车来客",
  alias: "chelaike",
  menus_state: "editing",
  head_img: "http://wx.qlogo.cn/mmopen/Q3auHgzwzM6ec3QuZVSjcCDv0ALPvYz0oXJKrjx96pphU8WFnBksjqa4CdqDOJRfciaJ4XTaiaJGQJibStycJmt7NfLYHnzbQxqKC9dhGTiaxNI/0",
  service_type_info: 2,
  verify_type_info: 0,
  business_info: "",
  qrcode_url: "http://mmbiz.qpic.cn/mmbiz/iapcb3hVJjUcYLLMN0DdFPSpTMHMr9X62ee2bhpGLXX49SQYQmWMlYUPRDeVNoZgBofhE6IkibEJLsKDicnkADWhg/0",
  state: "enabled"
  )

# 价格区间
price_range = EnumType.find_or_create_by(
  name: "价格", code: "price_range")
EnumValue.find_or_create_by(name: "10万以下", value: "-10000000", order: 1, enum_type: price_range)
EnumValue.find_or_create_by(name: "10-20万", value: "10000000-20000000", order: 2, enum_type: price_range)
EnumValue.find_or_create_by(name: "20-30万", value: "20000000-30000000", order: 3, enum_type: price_range)
EnumValue.find_or_create_by(name: "30-50万", value: "30000000-50000000", order: 4, enum_type: price_range)
EnumValue.find_or_create_by(name: "50-100万", value: "50000000-100000000", order: 5, enum_type: price_range)
EnumValue.find_or_create_by(name: "100万以上", value: "100000000-", order: 6, enum_type: price_range)

# 车龄区间
age_range = EnumType.find_or_create_by(name: "车龄", code: "age_range")
EnumValue.find_or_create_by(name: "1年内", value: "-365", order: 1, enum_type: age_range)
EnumValue.find_or_create_by(name: "2年内", value: "-730", order: 2, enum_type: age_range)
EnumValue.find_or_create_by(name: "3年内", value: "-1095", order: 3, enum_type: age_range)
EnumValue.find_or_create_by(name: "5年内", value: "-1825", order: 4, enum_type: age_range)
EnumValue.find_or_create_by(name: "8年内", value: "-2920", order: 5, enum_type: age_range)
EnumValue.find_or_create_by(name: "8年以上", value: "2920-", order: 6, enum_type: age_range)

# 车型
car_type = EnumType.find_or_create_by(name: "车型", code: "car_type")
EnumValue.find_or_create_by(name: "小轿车", value: "small_car", order: 1, enum_type: car_type)
EnumValue.find_or_create_by(name: "MPV", value: "mpv", order: 2, enum_type: car_type)
EnumValue.find_or_create_by(name: "SUV", value: "suv", order: 3, enum_type: car_type)
EnumValue.find_or_create_by(name: "跑车", value: "sports_car", order: 4, enum_type: car_type)
EnumValue.find_or_create_by(name: "皮卡", value: "pickup_trucks", order: 5, enum_type: car_type)
EnumValue.find_or_create_by(name: "微面", value: "small_van", order: 6, enum_type: car_type)
EnumValue.find_or_create_by(name: "电动车", value: "electrocar", order: 7, enum_type: car_type)
EnumValue.find_or_create_by(name: "其它", value: "other", order: 8, enum_type: car_type)

# 里程
mileage = EnumType.find_or_create_by(name: "里程", code: "mileage")
EnumValue.find_or_create_by(name: "1万公里内", value: "-1", order: 1, enum_type: mileage)
EnumValue.find_or_create_by(name: "2万公里内", value: "-2", order: 2, enum_type: mileage)
EnumValue.find_or_create_by(name: "3万公里内", value: "-3", order: 3, enum_type: mileage)
EnumValue.find_or_create_by(name: "5万公里内", value: "-5", order: 4, enum_type: mileage)
EnumValue.find_or_create_by(name: "5万公里以上", value: "5-", order: 5, enum_type: mileage)

# 排量
displacement = EnumType.find_or_create_by(name: "排量", code: "displacement")
EnumValue.find_or_create_by(name: "1.0L以及以下", value: "-1", order: 1, enum_type: displacement)
EnumValue.find_or_create_by(name: "1.0L-1.6L", value: "1-1.6", order: 2, enum_type: displacement)
EnumValue.find_or_create_by(name: "1.6L-2.0L", value: "1.6-2", order: 3, enum_type: displacement)
EnumValue.find_or_create_by(name: "2.0L-3.0L", value: "2-3", order: 4, enum_type: displacement)
EnumValue.find_or_create_by(name: "3.0L-4.0L", value: "3-4", order: 5, enum_type: displacement)
EnumValue.find_or_create_by(name: "4.0L以上", value: "4-", order: 6, enum_type: displacement)

# 排放标准
emission_standard = EnumType.find_or_create_by(name: "排放标准", code: "emission_standard")
EnumValue.find_or_create_by(name: "国1", value: "guo_1", order: 1, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "国2", value: "guo_2", order: 2, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "国3", value: "guo_3", order: 3, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "国4", value: "guo_4", order: 4, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "国5", value: "guo_5", order: 5, enum_type: emission_standard)

## 欧标标准
EnumValue.find_or_create_by(name: "欧1", value: "eu_1", order: 6, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "欧2", value: "eu_2", order: 7, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "欧3", value: "eu_3", order: 8, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "欧4", value: "eu_4", order: 9, enum_type: emission_standard)
EnumValue.find_or_create_by(name: "欧5", value: "eu_5", order: 10, enum_type: emission_standard)

# 燃油类型
fuel_type = EnumType.find_or_create_by(name: "燃油类型", code: "fuel_type")
EnumValue.find_or_create_by(name: "汽油", value: "gasoline", order: 1, enum_type: fuel_type)
EnumValue.find_or_create_by(name: "柴油", value: "diesel", order: 2, enum_type: fuel_type)
EnumValue.find_or_create_by(name: "天然气", value: "gas", order: 3, enum_type: fuel_type)
EnumValue.find_or_create_by(name: "纯电动", value: "electric", order: 4, enum_type: fuel_type)
EnumValue.find_or_create_by(name: "混合动力", value: "hybrid", order: 5, enum_type: fuel_type)

# 变速箱
transmission = EnumType.find_or_create_by(name: "变速箱", code: "transmission")
EnumValue.find_or_create_by(name: "手动", value: "manual", order: 1, enum_type: transmission)
EnumValue.find_or_create_by(name: "自动", value: "auto", order: 2, enum_type: transmission)
EnumValue.find_or_create_by(name: "手自一体", value: "manual_automatic", order: 3, enum_type: transmission)
EnumValue.find_or_create_by(name: "双离合", value: "dsg", order: 4, enum_type: transmission)
EnumValue.find_or_create_by(name: "无级变速", value: "cvt", order: 5, enum_type: transmission)
EnumValue.find_or_create_by(name: "其它", value: "other", order: 6, enum_type: transmission)

# 颜色
color = EnumType.find_or_create_by(name: "颜色", code: "color")
EnumValue.find_or_create_by(name: "黑色", value: "黑色", order: 1, enum_type: color)
EnumValue.find_or_create_by(name: "白色", value: "白色", order: 2, enum_type: color)
EnumValue.find_or_create_by(name: "银灰色", value: "银灰色", order: 3, enum_type: color)
EnumValue.find_or_create_by(name: "蓝色", value: "蓝色", order: 4, enum_type: color)
EnumValue.find_or_create_by(name: "红色", value: "红色", order: 5, enum_type: color)
EnumValue.find_or_create_by(name: "深灰色", value: "深灰色", order: 6, enum_type: color)
EnumValue.find_or_create_by(name: "绿色", value: "绿色", order: 7, enum_type: color)
EnumValue.find_or_create_by(name: "黄色", value: "黄色", order: 8, enum_type: color)
EnumValue.find_or_create_by(name: "香槟色", value: "香槟色", order: 9, enum_type: color)
EnumValue.find_or_create_by(name: "橙色", value: "橙色", order: 10, enum_type: color)
EnumValue.find_or_create_by(name: "棕色", value: "棕色", order: 11, enum_type: color)
EnumValue.find_or_create_by(name: "紫色", value: "紫色", order: 12, enum_type: color)
EnumValue.find_or_create_by(name: "其他", value: "其他", order: 13, enum_type: color)

# 排序方法 - 有必要存数据库吗?
sort = EnumType.find_or_create_by(name: "排序", code: "sort")
EnumValue.find_or_create_by(name: "默认排序", value: "id", additional_info: "desc", order: 1, enum_type: sort)
EnumValue.find_or_create_by(name: "价格最低", value: "online_price_cents", additional_info: "asc", order: 2, enum_type: sort)
EnumValue.find_or_create_by(name: "价格最高", value: "online_price_cents", additional_info: "desc", order: 3, enum_type: sort)
EnumValue.find_or_create_by(name: "车龄最短", value: "age", additional_info: "asc", order: 4, enum_type: sort)
EnumValue.find_or_create_by(name: "里程最少", value: "milage", additional_info: "asc", order: 5, enum_type: sort)
EnumValue.find_or_create_by(name: "最新发布", value: "id", additional_info: "desc", order: 6, enum_type: sort)
