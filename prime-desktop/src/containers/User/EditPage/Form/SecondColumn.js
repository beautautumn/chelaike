import React, { Component, PropTypes } from 'react'
import { FormItem, RadioGroup, MultiRoleSelect } from 'components'
import DeviceNumbersInput from './DeviceNumbersInput'
import { Col, Radio, Input } from 'antd'

export default class SecondColumn extends Component {
  static propTypes = {
    roles: PropTypes.array,
    fields: PropTypes.object.isRequired,
    currentCompany: PropTypes.object.isRequired
  }

  render() {
    const { fields, currentCompany, roles } = this.props

    const formItemLayout = {
      labelCol: { span: 8 },
      wrapperCol: { span: 16 }
    }

    return (
      <Col span="12">
        <FormItem {...formItemLayout} label="权限类型：">
          <RadioGroup {...fields.authorityType}>
            <Radio key="role" value="role">关联角色</Radio>
            <Radio key="custom" value="custom">单独设置</Radio>
          </RadioGroup>
        </FormItem>

        {fields.authorityType.value === 'role' &&
          <FormItem {...formItemLayout} label="关联角色：">
            <MultiRoleSelect roles={roles} {...fields.authorityRoleIds} />
          </FormItem>
        }

        <FormItem {...formItemLayout} label="限制电脑登录：">
          <RadioGroup {...fields.settings.macAddressLock}>
            <Radio key="true" value>是</Radio>
            <Radio key="false" value={false}>否</Radio>
          </RadioGroup>
        </FormItem>

        {fields.settings.macAddressLock.value &&
          <FormItem field={fields.macAddress} wrapperCol={{ span: 22, offset: 2 }}>
            <Input
              type="text"
              placeholder="MAC地址"
              {...fields.macAddress}
            />
          </FormItem>
        }

        <FormItem {...formItemLayout} label="限制手机登录：">
          <RadioGroup {...fields.settings.deviceNumberLock}>
            <Radio key="true" value>是</Radio>
            <Radio key="false" value={false}>否</Radio>
          </RadioGroup>
        </FormItem>

        {fields.settings.deviceNumberLock.value &&
          <DeviceNumbersInput {...fields.deviceNumbers} />
        }

        <FormItem {...formItemLayout} label="是否联盟联系人：">
          <RadioGroup {...fields.isAllianceContact}>
            <Radio key="true" value>是</Radio>
            <Radio key="false" value={false}>否</Radio>
          </RadioGroup>
        </FormItem>

        {!currentCompany.settings.unifiedManagement &&
          <FormItem {...formItemLayout} label="允许跨店查询：">
            <RadioGroup {...fields.settings.crossShopRead}>
              <Radio key="true" value>是</Radio>
              <Radio key="false" value={false}>否</Radio>
            </RadioGroup>
          </FormItem>
        }

        {!currentCompany.settings.unifiedManagement &&
          <FormItem {...formItemLayout} label="允许跨店操作：">
            <RadioGroup {...fields.settings.crossShopEdit}>
              <Radio key="true" value>是</Radio>
              <Radio key="false" value={false}>否</Radio>
            </RadioGroup>
          </FormItem>
        }

        {!currentCompany.settings.unifiedManagement &&
          <FormItem {...formItemLayout} label="允许跨店统计查询：">
            <RadioGroup {...fields.settings.crossShopReadStatistic}>
              <Radio key="true" value>是</Radio>
              <Radio key="false" value={false}>否</Radio>
            </RadioGroup>
          </FormItem>
        }

        <FormItem {...formItemLayout} label="启用状态：">
          <RadioGroup {...fields.state}>
            <Radio key="enabled" value="enabled">启用</Radio>
            <Radio key="disabled" value="disabled">禁用</Radio>
          </RadioGroup>
        </FormItem>
      </Col>
    )
  }
}
