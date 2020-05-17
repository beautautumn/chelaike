import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { Datepicker, FormItem } from 'components'
import date from 'helpers/date'
import { errorFocus } from 'decorators'
import validation from './validation'
import { Form as AntdForm, Radio, Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import { price } from 'helpers/car'

@reduxForm({
  form: 'carReservationCancel',
  fields: ['canceledAt', 'cancelablePriceWan', 'note'],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    reservation: PropTypes.object.isRequired
  }

  render() {
    const { fields, car, reservation } = this.props
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
            value={reservation.salesType}
            disabled
          >
            <Radio value="retail">零售</Radio>
            <Radio value="wholesale">批发</Radio>
          </Radio.Group>
        </FormItem>
        <FormItem {...formItemLayout} required field={fields.customerChannelId} label="客户来源：">
          <p className="ant-form-text">
            {reservation.customerChannel && reservation.customerChannel.name}
          </p>
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} required field={fields.sellerId} label="成交员工：">
              <p className="ant-form-text">{reservation.seller.name}</p>
            </FormItem>
            <FormItem {...inlineItemLayout} field={fields.closingCostWan} label="成交价：">
              <p className="ant-form-text">{price(reservation.closingCostWan, '万元')}</p>
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem {...inlineItemLayout} required field={fields.reservedAt} label="预定时间：">
              <p className="ant-form-text">{date(reservation.reservedAt)}</p>
            </FormItem>
            <FormItem {...inlineItemLayout} required field={fields.depositWan} label="定金：">
              <p className="ant-form-text">{price(reservation.depositWan, '万元')}</p>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} required field={fields.customerName} label="客户姓名：">
              <p className="ant-form-text">{reservation.customerName}</p>
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem {...inlineItemLayout} required field={fields.reservedAt} label="联系电话：">
              <p className="ant-form-text">{reservation.customerPhone}</p>
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} label="客户地址：">
              <p className="ant-form-text">{reservation.customerLocationProvince}</p>
            </FormItem>
          </Col>
          <Col span="9" offset="1">
            <FormItem label="">
              <p className="ant-form-text">{reservation.customerLocationCity}</p>
            </FormItem>
          </Col>
        </Row>
        <FormItem {...formItemLayout} label=" ">
          <p className="ant-form-text">{reservation.customerLocationAddress}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="证件号：">
          <p className="ant-form-text">{reservation.customerIdcard}</p>
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...inlineItemLayout} required field={fields.canceledAt} label="退订日期：">
              <Datepicker id="canceledAt" {...fields.canceledAt} />
            </FormItem>
          </Col>
          <Col span="10">
            <FormItem
              {...inlineItemLayout}
              required
              field={fields.cancelablePriceWan}
              label="退款金额："
            >
              <NumberInput {...fields.cancelablePriceWan} addonAfter="万元" />
            </FormItem>
          </Col>
        </Row>
        <FormItem {...formItemLayout} label="备注：">
          <Textarea rows={2} className="ant-input ant-input-lg" {...fields.note} />
        </FormItem>
      </AntdForm>
    )
  }
}
