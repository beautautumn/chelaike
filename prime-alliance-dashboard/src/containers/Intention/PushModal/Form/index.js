import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Row, Col, Input } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem, Datepicker, Select } from 'components'
import { AddCarButton, CarList } from 'containers/Intention/components'
import validation from './validation'

const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 17 },
}

const stateOptions = {
  seek: {
    processing: '继续跟进',
    interviewed: '预约看车',
    failed: '已战败',
    invalid: '已失效',
  },
  sale: {
    processing: '继续跟进',
    interviewed: '预约评估',
    completed: '已成交',
    hall_consignment: '展厅寄卖',
    online_consignment: '网络寄卖',
    failed: '已战败',
    invalid: '已失效',
  },
}

@reduxForm({
  form: 'intentionBook',
  fields: [
    'state', 'intentionLevelId', 'processingTime', 'interviewedTime', 'companyId',
    'note', 'carIds', 'estimatedPriceWan', 'intentionType',
  ],
  validate: validation,
})
export default class Form extends Component {
  static propTypes = {
    intentionLevelsById: PropTypes.object,
    intention: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    handleAddCar: PropTypes.func.isRequired,
    carsById: PropTypes.object,
  }

  renderProcessingTimeInput() {
    const { fields } = this.props
    const lables = {
      failed: '战败日期',
      invalid: '失效日期',
    }
    const label = lables[fields.state.value]

    if (!label) return null

    return (
      <Row>
        <Col span="12">
          <FormItem {...formItemLayout} required label={label} field={fields.processingTime}>
            <Datepicker {...fields.processingTime} />
          </FormItem>
        </Col>
      </Row>
    )
  }

  render() {
    const {
      intention,
      fields,
      handleSubmit,
      handleAddCar,
      carsById,
    } = this.props

    const cars = fields.carIds.value.map(id => carsById[id])

    return (
      <AForm horizontal onSubmit={handleSubmit}>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} required label="跟进结果" field={fields.state}>
              <Select
                items={stateOptions[intention.intentionType]}
                {...fields.state}
              />
            </FormItem>
          </Col>
          {
            ['processing', 'interviewed', 'completed'].includes(fields.state.value) &&
              <Col span="12" pull="1">
                <FormItem {...formItemLayout} label="客户级别：" >
                  <Select.IntentionLevel {...fields.intentionLevelId} />
                </FormItem>
              </Col>
          }
        </Row>

        {this.renderProcessingTimeInput()}

        {fields.state.value === 'interviewed' &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} required label="预约时间" field={fields.interviewedTime}>
                <Datepicker format="datetime" {...fields.interviewedTime} />
              </FormItem>
            </Col>
          </Row>
        }

        {fields.state.value === 'processing' &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} required label="下次跟进" field={fields.processingTime}>
                <Datepicker {...fields.processingTime} />
              </FormItem>
            </Col>
          </Row>
        }

        <Row>
          <Col>
            <CarList cars={cars} />
          </Col>
        </Row>

        {fields.state.value === 'interviewed' &&
          <Row>
            <Col>
              <FormItem>
                <AddCarButton
                  type="checkbox"
                  handleAdd={handleAddCar}
                  {...fields.carIds}
                />
              </FormItem>
            </Col>
          </Row>
        }

        {intention.intentionType === 'sale' && fields.checked.value &&
          <FormItem {...formItemLayout} required label="评估价格" field={fields.estimatedPriceWan}>
            <NumberInput {...fields.estimatedPriceWan} addonAfter="万元" />
          </FormItem>
        }

        <FormItem
          labelCol={{ span: 3 }}
          wrapperCol={{ span: 20 }}
          required
          label="跟进说明"
          field={fields.note}
        >
          <Input type="textarea" autosize {...fields.note} />
        </FormItem>
      </AForm>
    )
  }
}
