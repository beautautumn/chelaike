import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input } from 'antd'
import { NumberInput } from '@prime/components'
import {
  FormItem,
  Datepicker,
  UserSelect,
  ShopSelect,
} from 'components'
import { autoId } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'inStockPriceEditForFinance',
  fields: [
    'shopId', 'acquirerId', 'acquiredAt',
    'acquisitionPriceWan', 'note',
  ],
  validate: validation
})
@autoId
export default class Form extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired
  }

  render() {
    const { car, fields, autoId } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    return (
      <AForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>

        <FormItem
          id={autoId()}
          {...formItemLayout}
          label="所属门店："
          required
          field={fields.shopId}
        >
          <ShopSelect id={autoId()} {...fields.shopId} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="收购员："
          field={fields.acquirerId}
        >
          <UserSelect id={autoId()} as="all" {...fields.acquirerId} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="入库日期："
          field={fields.acquiredAt}
        >
          <Datepicker id={autoId()} {...fields.acquiredAt} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="入库价格："
          field={fields.acquisitionPriceWan}
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.acquisitionPriceWan} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="调整说明：">
          <Input id={autoId()} type="textarea" rows="4" {...fields.note} />
        </FormItem>
      </AForm>
    )
  }
}
