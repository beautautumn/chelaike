import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem, Datepicker } from 'components'
import { errorFocus, autoId } from 'decorators'
import { price } from 'helpers/car'
import validation from './validation'

@reduxForm({
  form: 'stockOutAcquisitionRefundInventory',
  fields: ['stockOutInventoryType', 'refundedAt', 'refundPriceWan'],
  validate: validation
})
@errorFocus
@autoId
export default class AcquisitionRefundForm extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    autoId: PropTypes.func.isRequired
  }

  render() {
    const { car, fields, autoId } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    return (
      <Form horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>

        <FormItem {...formItemLayout} label="车辆标价：">
          <p className="ant-form-text">{price(car.showPriceWan, '万元')}</p>
        </FormItem>

        <FormItem {...formItemLayout} label="收购价格：">
          <p className="ant-form-text">{price(car.acquisitionPriceWan, '万元')}</p>
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="退车日期："
          field={fields.refundedAt}
        >
          <Datepicker id={autoId()} {...fields.refundedAt} />
        </FormItem>

        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.refundPriceWan}
          label="退车价格："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.refundPriceWan} />
        </FormItem>
      </Form>
    )
  }
}
