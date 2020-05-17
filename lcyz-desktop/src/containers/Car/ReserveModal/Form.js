import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import {
  FormItem,
  Datepicker,
  RegionSelectGroup,
  ProvinceSelect,
  CitySelect,
  UserSelect,
  ChannelSelect,
  InsuranceCompanySelect,
} from 'components'
import { errorFocus } from 'decorators'
import validation from './validation'
import { Form as AntdForm, Radio, Input, Row, Col } from 'antd'

import { NumberInput } from '@prime/components'

@reduxForm({
  form: 'carReservation',
  fields: [
    'salesType', 'customerChannelId', 'sellerId', 'reservedAt', 'closingCostWan',
    'depositWan', 'note', 'customerName', 'customerPhone', 'customerLocationProvince',
    'customerLocationCity', 'customerLocationAddress', 'customerIdcard', 'proxyInsurance',
    'insuranceCompanyId', 'commercialInsuranceFeeYuan', 'compulsoryInsuranceFeeYuan'
  ],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired
  }

  render() {
    const { car, fields } = this.props
    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 18 },
    }
    const inlineItemLayout = {
      labelCol: { span: 8 },
      wrapperCol: { span: 16 },
    }

    return (
      <AntdForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>
        <FormItem required {...formItemLayout} label="销售类型：">
          <Radio.Group
            {...fields.salesType}
            onChange={event => fields.salesType.onChange(event.target.value)}
          >
            <Radio value="retail">零售</Radio>
            <Radio value="wholesale">批发</Radio>
          </Radio.Group>
        </FormItem>
        <FormItem {...formItemLayout} required field={fields.customerChannelId} label="客户来源：">
          <ChannelSelect {...fields.customerChannelId} />
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} required field={fields.sellerId} label="成交员工：">
              <UserSelect {...fields.sellerId} as="all" />
            </FormItem>
            <FormItem {...inlineItemLayout} field={fields.closingCostWan} label="成交价：">
              <NumberInput {...fields.closingCostWan} addonAfter="万元" />
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem {...inlineItemLayout} required field={fields.reservedAt} label="预定时间：">
              <Datepicker id="reservedAt" {...fields.reservedAt} />
            </FormItem>
            <FormItem {...inlineItemLayout} required field={fields.depositWan} label="定金：">
              <NumberInput {...fields.depositWan} addonAfter="万元" />
            </FormItem>
          </Col>
        </Row>
        <FormItem {...formItemLayout} label="备注：">
          <Textarea rows={2} className="ant-input ant-input-lg" {...fields.note} />
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} required field={fields.customerName} label="客户姓名：">
              <Input {...fields.customerName} />
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem {...inlineItemLayout} required field={fields.customerPhone} label="联系电话：">
              <Input {...fields.customerPhone} />
            </FormItem>
          </Col>
        </Row>
        <RegionSelectGroup>
          <Row>
            <Col span="12">
              <FormItem {...inlineItemLayout} label="客户地址：">
                <ProvinceSelect {...fields.customerLocationProvince} />
              </FormItem>
            </Col>
            <Col span="9" offset="1">
              <FormItem label="">
                <CitySelect {...fields.customerLocationCity} />
              </FormItem>
            </Col>
          </Row>
        </RegionSelectGroup>
        <FormItem {...formItemLayout} label=" ">
          <Input placeholder="详细地址" {...fields.customerLocationAddress} />
        </FormItem>
        <FormItem {...formItemLayout} label="证件号：">
          <Input {...fields.customerIdcard} />
        </FormItem>

        <FormItem {...formItemLayout} label="代办保险：">
          <Radio.Group
            {...fields.proxyInsurance}
            onChange={event => fields.proxyInsurance.onChange(event.target.value)}
          >
            <Radio value>是</Radio>
            <Radio value={false}>否</Radio>
          </Radio.Group>
        </FormItem>

        {fields.proxyInsurance.value && [
          <FormItem
            key="insuranceCompanyId"
            {...formItemLayout}
            label="保险公司："
          >
            <InsuranceCompanySelect {...fields.insuranceCompanyId} />
          </FormItem>,

          <FormItem
            key="commercialInsuranceFeeYuan"
            {...formItemLayout}
            label="商业险："
          >
            <NumberInput addonAfter="元" {...fields.commercialInsuranceFeeYuan} />
          </FormItem>,

          <FormItem
            key="compulsoryInsuranceFeeYuan"
            {...formItemLayout}
            label="交强险："
          >
            <NumberInput addonAfter="元" {...fields.compulsoryInsuranceFeeYuan} />
          </FormItem>
        ]}
      </AntdForm>
    )
  }
}
