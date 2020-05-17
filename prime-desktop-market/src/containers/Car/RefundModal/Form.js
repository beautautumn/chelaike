import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { reduxForm } from 'redux-form'
import { Datepicker, FormItem } from 'components'
import Textarea from 'react-textarea-autosize'
import { errorFocus } from 'decorators'
import get from 'lodash/get'
import { Form as AntdForm } from 'antd'
import { NumberInput } from '@prime/components'
import { price } from 'helpers/car'
import validate from './validation'

@reduxForm({
  form: 'carRefund',
  fields: ['refundedAt', 'refundPriceWan', 'note'],
  validate
})
@errorFocus
export default class Form extends PureComponent {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    stockOutInventory: PropTypes.object.isRequired
  }

  render() {
    const { fields, car, stockOutInventory } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    return (
      <AntdForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="成交日期：">
          <p className="ant-form-text">{stockOutInventory.completedAt}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="成交员工：">
          <p className="ant-form-text">{get(stockOutInventory, 'seller.name')}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="成交金额：">
          <p className="ant-form-text">{price(stockOutInventory.closingCostWan, '万元')}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="合计应收：">
          <p className="ant-form-text">{price(stockOutInventory.closingCostWan, '万元')}</p>
        </FormItem>
        <FormItem {...formItemLayout} label="定金：">
          <p className="ant-form-text">{price(stockOutInventory.depositWan, '万元')}</p>
        </FormItem>
        <FormItem required field={fields.refundedAt} {...formItemLayout} label="回库日期：">
          <Datepicker {...fields.refundedAt} />
        </FormItem>
        <FormItem required field={fields.refundPriceWan} {...formItemLayout} label="退款金额：">
          <NumberInput addonAfter="万元" {...fields.refundPriceWan} />
        </FormItem>
        <FormItem {...formItemLayout} label="退款描述：">
          <Textarea className="ant-input ant-input-lg" rows={2} {...fields.note} />
        </FormItem>
      </AntdForm>
    )
  }
}
