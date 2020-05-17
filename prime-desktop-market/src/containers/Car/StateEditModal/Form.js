import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { Select, Datepicker, FormItem } from 'components'
import map from 'lodash/map'
import { errorFocus } from 'decorators'
import validation from './validation'
import { Form as AntdForm, Radio, Input } from 'antd'

@reduxForm({
  form: 'carState',
  fields: ['sellable', 'state', 'occurredAt', 'predictedRestockedAt', 'note'],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    carStates: PropTypes.object.isRequired
  }

  render() {
    const { car, fields, carStates } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 },
    }

    return (
      <AntdForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <Input value={car.systemName} disabled />
        </FormItem>
        <FormItem {...formItemLayout} label="是否在微店展示：">
          <Radio.Group
            {...fields.sellable}
            onChange={event => fields.sellable.onChange(event.target.value)}
          >
            <Radio value>是</Radio>
            <Radio value={false}>否</Radio>
          </Radio.Group>
        </FormItem>
        <FormItem {...formItemLayout} required label="车辆状态：">
          <Select
            items={map(carStates, (text, key) => ({ value: key, text }))}
            prompt="选择状态"
            {...fields.state}
          />
        </FormItem>
        <FormItem {...formItemLayout} required label="发生时间：">
          <Datepicker {...fields.occurredAt} />
        </FormItem>
        {fields.state.value !== 'in_hall' && (
          <FormItem {...formItemLayout} label="预计返回展厅时间：">
            <Datepicker {...fields.predictedRestockedAt} />
          </FormItem>
        )}
        <FormItem {...formItemLayout} label="状态描述：">
          <Textarea rows={2} className="ant-input ant-input-lg" {...fields.note} />
        </FormItem>
      </AntdForm>
    )
  }
}
