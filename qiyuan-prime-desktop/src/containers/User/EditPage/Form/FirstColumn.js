import React from 'react'
import { FormItem, CompanySelect, MultiRoleSelect } from 'components'
import { Input, Col, Checkbox } from 'antd'

export default ({ fields, roles, currentUser }) => {
  let passwordPlaceholder = '最短6位，区分大小写'
  if (fields.id.value) {
    passwordPlaceholder += '，如果不需要修改密码，请不要填写'
  }

  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 }
  }

  return (
    <Col span="24">
      {/* 防止360浏览自动填写 */}
      <input type="text" style={{ display: 'none' }} />
      <input type="password" style={{ display: 'none' }} />

      <FormItem
        {...formItemLayout}
        required
        label="姓名："
        field={fields.name}
      >
        <Input type="text" {...fields.name} />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required
        label="手机号码："
        field={fields.phone}
      >
        <Input type="text" {...fields.phone} />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required={!fields.id.value}
        label="密码："
        field={fields.password}
      >
        <Input
          autoComplete="off"
          type="password"
          placeholder={passwordPlaceholder}
          {...fields.password}
        />
      </FormItem>

      <FormItem
        {...formItemLayout}
        required={!fields.id.value}
        label="确认密码："
        field={fields.passwordConfirmation}
      >
        <Input
          autoComplete="off"
          type="password"
          {...fields.passwordConfirmation}
        />
      </FormItem>

      {currentUser.userType === 'platform' && !currentUser.companyId &&
        <FormItem {...formItemLayout} label="所属公司：" field={fields.companyId}>
          <CompanySelect {...fields.companyId} />
        </FormItem>
      }

      {currentUser.userType === 'platform' && currentUser.companyId &&
        <FormItem {...formItemLayout} label="所属公司：" field={fields.companyId}>
          {fields.companyName.value}
        </FormItem>
      }

      {fields.shopName.value &&
        <FormItem {...formItemLayout} label="所属车商：">
          {fields.shopName.value}
        </FormItem>
      }

      <FormItem {...formItemLayout} label="角色名：">
        <MultiRoleSelect roles={roles} {...fields.authorityRoleIds} />
      </FormItem>

      {!fields.id.value &&
        <FormItem {...formItemLayout} label="短信提醒：">
          <Checkbox {...fields.needSmsNotice} />
        </FormItem>
      }
    </Col>
  )
}
