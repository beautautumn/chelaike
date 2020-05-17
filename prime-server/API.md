FORMAT: 1A
HOST: http://prime.lina.che3bao.com/api/v1/

# Autobots Prime

Prime 服务端 API 文档。


## Group 用户

## User [/users/]

属性:

+ username - 用户名
+ phone - 手机号
+ last_sign_in_at - 最后登录时间
+ current_sign_in_at - 当前登录时间
+ company_id - 公司ID
+ shop_id - 分店ID
+ authority_type - 权限类型
+ authorities - 权限
+ created_at - 创建时间
+ updated_at - 更新时间

### 用户注册 [POST /users/]

+ Request

        {
            user: {
                user_name: "用户名",
                password: "password"
            }
        }

+ Response 200 (application/json)

        {
            user: {
                id: 602622571,
                username: "DavidFincher",
                authority_type: "role",
                authorities: [],
                authority_roles: []
            }
        }

## Password [/users/{user_id}/password/]

属性:

+ phone - 手机号码
+ pass_reset_token - 密码重置验证码
+ password - 密码
    
### 请求重置密码 [GET /users/{user_id}/password/]

+ Parameters
    + user_id: 340065689 - 用户ID

+ Request

        {
            user: { 
                phone: "18668237883"
            }
        }
    
+ Response 200 (application/json)

        {
            user: {
                id: 340065689,
                username: "Nolan",
                token: "AutobotsAuth 340065689:xATVSeIISctcCSxbIR2BI0KGsvE=",
                pass_reset_token: "purr"
            }
        }
        
### 重置密码 [PUT /users/{user_id}/password]

+ Parameters
    + USER_phone: 18668237883 (required, number) - 手机号
    + USER_pass_reset_token: purr (required, string) - 验证码
    + USER_password: IChangeThePassword (required, string) - 新密码
    + user_id: 340065689 - 用户ID
    
+ Response 200 (application/json)

        {
            user: {
                id: 340065689,
                username: "Nolan",
                token: "AutobotsAuth 340065689:xATVSeIISctcCSxbIR2BI0KGsvE=",
                pass_reset_token: ""
            }
        }

## Authority Roles [/users/{user_id}/authority_roles/]

用户角色

属性:

+ authority_type - 权限类型
+ authorities - 权限
+ authority_roles - 角色详情

### 查询用户角色 [GET /users/{user_id}/authority_roles]

+ Parameters
    + user_id: 602622570 - 用户ID

+ Response 200 (application/json)
        
        {
          user: {
              id: 602622570, 
              authority_type: "role", 
              authorities: ["在库车辆查询"], 
              authority_roles: [
                                  { 
                                      id: 975447484, 
                                      name: "经理"
                                  }
                              ]
          }
        }        

## Authorities [/users/{user_id}/authorities/]

用户权限

属性:

+ authority_type - 权限类型
+ authorities - 权限
+ authority_roles - 角色详情

### 添加用户权限 [POST /users/{user_id}/authority_roles/]

+ Parameters
    + user_id: 602622570 - 用户ID

+ Request

        {
            user: { 
                authority_role_id: salesman.id
            }
        }

+ Response 200 (application/json)

        {
            user: {
                id: 602622570,
                authority_type: "role",
                authorities: [
                                "员工权限管理", 
                                "在库车辆查询"
                            ],
                authority_roles: [
                                    {
                                        id: 975447484, 
                                        name: "经理"
                                    }, 
                                    {
                                        id: 733051121, 
                                        name: "销售员"
                                    }
                                ]
            }
        }

### 删除用户角色 [DELETE /users/{user_id}/authority_roles/{authority_role_id}]

+ Parameters
    + user_id: 602622570 - 用户ID
    + authority_role_id: 975447484 (required, number) - 角色ID
    
+ Response 200 (application/json)
        {
            user: {
                id: 602622570, 
                authority_type: "role", 
                authorities: [], 
                authority_roles: []
            }
        }

### 自定义用户权限 [PUT]

+ Parameters
    + user_id: 602622570
    + authorities: [ "库存量统计", "销售员业绩" ] (required, array) - 权限

+ Response 200 (application/json)
        {
            user: {
                id: 602622570, 
                authority_type: "custom", 
                authorities: [
                                "库存量统计",
                                "销售员业绩"
                            ], 
                authority_roles: []
            }
        }

## Group Sessions

## Session [/sessions/]

### 用户登录 [POST /sessions]

+ Request

        {
            user: {
                username: "用户名",
                password: "密码"
            }
        }
    
+ Response 200 (application/json)

        {
            user: {
                id: 340065689,
                username: "Nolan",
                authorities: [],
                token: "AutobotsAuth 340065689:nEtjR/pg+xj1YYUGKUc+7Nz7zk4="
            }
        }

## Group 公司

## Roles [/companies/{company_id}/authority_roles]

属性:

+ name - 公司名称
+ authority_roles - 公司所有角色
+ created_at - 创建时间
+ updated_at - 更新时间

### 获取角色 [GET]

+ Parameters
    + company_id: 259435032 - 公司ID
    
+ Response 200 (application/json)

        {
            authority_roles: [
                {
                    id: 975447484, 
                    name: "经理"
                }, 
                {
                    id: 733051121, 
                    name: "销售员"
                }
            ]
        }

### 创建角色 [POST /companies/{company_id}/authority_roles]

+ Parameters
    + company_id: 259435032 - 公司ID

+ Request

        {
            name: {
                name: "收购员"
            }
        }

+ Response 200 (application/json)
        {
            authority_role: {
                id: 975447485, 
                name: "收购员", 
                company: {
                            id: 259435032, 
                            name: "天车二手车"
                        }
            }
        }

## Group 渠道管理

## 所有渠道 [/companies/{company_id}/channels]

属性: 
+ name - 名称
+ note - 备注

### 获取所有渠道 [GET /companies/{company_id}/channels]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Response 200 (application/json)
        {
            channels: [
                {
                    id: 975484,
                    name: "宝马4S店",
                    company_id: 975447484,
                    note: "备注1"
                },
                {
                    id: 1234,
                    name: "宝来4S店",
                    company_id: 975447484,
                    note: "备注2"
                }
            ]
        }

### 创建渠道 [POST /companies/{company_id}/channels]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Request

        {
            channel: {
                name: "宝马4S店",
                note: "还是宝马的好"
            }
        }

+ Response 200 (application/json)

        {
            channel: {
                id: 123,
                name: "宝马4S店",
                note: "还是宝马的好",
                company_id: 259435032
            }
        }

### 修改渠道 [PUT /companies/{company_id}/channels/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Request

        {
            channel: { 
                name: "宝马"
            }
        }

+ Response 200 (application/json)

        {
            channel: {
                id: 123,
                name: "宝马",
                note: "还是宝马的好",
                company_id: 259435032
            }
        }

### 删除渠道 [DELETE /companies/{company_id}/channels/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Response 200 (application/json)

        {
          channel: {
              id: 123,
              name: "宝马",
              note: "还是宝马的好",
              company_id: 259435032
          }
        }


## Group 质保等级

## 所有质保等级 [/companies/{company_id}/warranties]

属性: 
+ name - 名称
+ company_id - 公司ID
+ fee - 费用(元)

### 获取所有渠道 [GET /companies/{company_id}/warranties]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Response 200 (application/json)
        {
            warranty: [
                {
                    id: 975484,
                    name: "A",
                    company_id: 975447484,
                    fee: 2000
                },
                {
                    id: 1234,
                    name: "B",
                    company_id: 975447484,
                    fee: 2000
                }   
            ]
        }

### 创建质保等级 [POST /companies/{company_id}/warranties]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Request

        {
            warranty: {
                name: "A",
                fee: "300"
            }
        }

+ Response 200 (application/json)

        {
            warranty: {
                id: 123,
                name: "A",
                fee: 300,
                company_id: 259435032
            }
        }

### 修改质保等级 [PUT /companies/{company_id}/warranties/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Request

        {
            warranty: { 
                name: "A"
            }
        }

+ Response 200 (application/json)

        {
            warranty: {
                id: 123,
                name: "A",
                fee: 300,
                company_id: 259435032
            }
        }

### 删除质保等级 [DELETE /companies/{company_id}/warranties/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Response 200 (application/json)

        {
            warranty:{
                id: 123,
                name: "A",
                fee: 300,
                company_id: 259435032
            }
        }



## Group 按揭公司

## 所有质保等级 [/companies/{company_id}/mortgage_company]

属性: 
+ name - 名称
+ company_id - 公司ID

### 获取按揭公司 [GET /companies/{company_id}/mortgage_companies]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Response 200 (application/json)
        {
          mortgage_companies: [
              {
                  id: 975484,
                  name: "广发",
                  company_id: 975447484
              },
              {
                  id: 1234,
                  name: "招商",
                  company_id: 975447484
              }
          ]
        }

### 创建按揭公司 [POST /companies/{company_id}/mortgage_companies]

+ Parameters
  + company_id: 259435032 - 公司ID

+ Request

        {
            mortgage_company: {
                name: "中信"
            }
        }

+ Response 200 (application/json)

        {
            mortgage_company: {
                id: 123,
                name: "中信",
                company_id: 259435032
            }
        }

### 修改按揭公司 [PUT /companies/{company_id}/mortgage_companies/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Request

        {
            mortgage_company: { 
                name: "中信"
            }
        }

+ Response 200 (application/json)

        {
            mortgage_company: {
                id: 123,
                name: "中信",
                company_id: 259435032
            }
        }

### 删除按揭公司 [DELETE /companies/{company_id}/mortgage_companies/{id}]

+ Parameters
  + company_id: 259435032 - 公司ID
  + id: 123

+ Response 200 (application/json)

        {
            mortgage_company: {
                id: 123,
                name: "广发",
                company_id: 259435032
            }
        }

