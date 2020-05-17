import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem, Datepicker } from 'components'
import { errorFocus, autoId } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'stockOutAllianceRefundInventory',
  fields: ['stockOutInventoryType', 'refundedAt', 'refundedPriceWan'],
  validate: validation
})
@errorFocus
@autoId
export default class AllianceRefundForm extends Component {
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

        <FormItem {...formItemLayout} label="所属联盟：">
          <p className="ant-form-text">{car.allianceStockInInventory.allianceName}</p>
        </FormItem>

        <FormItem {...formItemLayout} label="出库公司：">
          <p className="ant-form-text">{car.allianceStockInInventory.fromCompanyName}</p>
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

        <FormItem {...formItemLayout} label="出库价格：">
          <p className="ant-form-text">{car.allianceStockInInventory.closingCostWan} 万元</p>
        </FormItem>

        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.refundedPriceWan}
          label="退车价格："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.refundedPriceWan} />
        </FormItem>
      </Form>
    )
  }
}
