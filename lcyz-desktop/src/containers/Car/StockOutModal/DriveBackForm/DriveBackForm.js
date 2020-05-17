import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form, Input } from 'antd'
import { FormItem, Datepicker } from 'components'
import { autoId } from 'decorators'
import { price } from 'helpers/car'
import validation from './validation'

@reduxForm({
  form: 'stockOutDrivenBackInventory',
  fields: ['stockOutInventoryType', 'drivenBackAt', 'note'],
  validate: validation
})
@autoId
export default class DriveBackForm extends Component {
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

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="开回时间："
          field={fields.drivenBackAt}
        >
          <Datepicker id={autoId()} {...fields.drivenBackAt} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="备注：">
          <Input id={autoId()} type="textarea" rows="4" {...fields.note} />
        </FormItem>
      </Form>
    )
  }
}
