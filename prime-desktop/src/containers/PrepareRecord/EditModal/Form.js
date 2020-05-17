import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import { Datepicker, UserSelect, FormItem } from 'components'
import ItemsForm from './ItemsForm'
import validation from './validation'
import { errorFocus } from 'decorators'
import { Col, Input, Radio, Form as AntdForm } from 'antd'

@reduxForm({
  form: 'prepareRecord',
  fields: [
    'repairState', 'state', 'preparerId', 'startAt', 'endAt', 'note',
    'prepareItemsAttributes', 'totalAmountYuan'
  ],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired
  }

  render() {
    const { fields, car, enumValues } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 },
    }

    return (
      <AntdForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <Input value={car.systemName} disabled />
        </FormItem>
        <ItemsForm {...fields.prepareItemsAttributes} />
        <FormItem {...formItemLayout} label="维修现状：">
          <Radio.Group
            {...fields.repairState}
            onChange={event => fields.repairState.onChange(event.target.value)}
          >
            {Object.keys(enumValues.prepare_record.repair_state).reduce((accumulator, key) => {
              accumulator.push(
                <Radio key={key} value={key}>{enumValues.prepare_record.repair_state[key]}</Radio>
              )
              return accumulator
            }, [])}
          </Radio.Group>
        </FormItem>
        <FormItem {...formItemLayout} required label="整备状态：">
          <Radio.Group
            {...fields.state}
            onChange={event => fields.state.onChange(event.target.value)}
          >
            {Object.keys(enumValues.prepare_record.state).reduce((accumulator, key) => {
              accumulator.push(
                <Radio key={key} value={key}>{enumValues.prepare_record.state[key]}</Radio>
              )
              return accumulator
            }, [])}
          </Radio.Group>
        </FormItem>
        <FormItem {...formItemLayout} required label="整备员：">
          <UserSelect {...fields.preparerId} as="all" />
        </FormItem>
        <FormItem {...formItemLayout} label="开始时间：">
          <Col span="11">
            <Datepicker {...fields.startAt} />
          </Col>
          <Col span="12" offset="1">
            <Datepicker {...fields.endAt} />
          </Col>
        </FormItem>
        <FormItem {...formItemLayout} label="补充说明：">
          <Textarea rows={2} className="ant-input ant-input-lg" {...fields.note} />
        </FormItem>
      </AntdForm>
    )
  }
}
