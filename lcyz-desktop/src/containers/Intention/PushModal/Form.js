import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { reduxForm } from 'redux-form'
import { show as showModal } from 'redux-modal'
import Textarea from 'react-textarea-autosize'
import moment from 'moment'
import {
  Select,
  Datepicker,
  IntentionLevelSelect,
  FormItem,
  CarItem,
  DefeatReasonSelect,
} from 'components'
import SeekingCars from './SeekingCars'
import { SeekingCarsModal } from '..'
import validation from './validation'
import { Form as AForm, Radio, Row, Col, Input, Button } from 'antd'
import { NumberInput } from '@prime/components'
const RadioGroup = Radio.Group

const formItemLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 15 },
}

const firstColLayout = {
  labelCol: { span: 8 },
  wrapperCol: { span: 14 },
}

const secondColLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 10 },
}

const stateOptions = {
  seek: {
    processing: '继续跟进',
    interviewed: '预约看车',
    failed: '已战败',
    completed: '已成交',
  },
  sale: {
    processing: '继续跟进',
    interviewed: '预约评估',
    completed: '已成交',
    hall_consignment: '展厅寄卖',
    online_consignment: '网络寄卖',
    failed: '已战败',
  }
}

function mapStateToProps(state) {
  return {
    intentionLevelsById: state.entities.intentionLevels
  }
}

function mapDispathcToProps(dispatch) {
  return {
    ...bindActionCreators({
      showModal
    }, dispatch)
  }
}

@reduxForm({
  form: 'intentionPushHistory',
  fields: [
    'state', 'intentionLevelId', 'processingTime', 'interviewedTime', 'checked',
    'note', 'carIds', 'estimatedPriceWan', 'intentionType', 'consignedAt', 'manually',
    'closingCarId', 'closingCarName', 'depositWan', 'closingCostWan', 'intentionPushFailReasonId',
  ],
  validate: validation
}, mapStateToProps, mapDispathcToProps)
export default class Form extends PureComponent {
  static propTypes = {
    intentionLevelsById: PropTypes.object,
    intention: PropTypes.object.isRequired,
    showModal: PropTypes.func.isRequired,
    carsById: PropTypes.object
  }

  handleSeekingCarsEdit = (selection) => () => {
    this.props.showModal('seekingCarsEdit', { selection })
  }

  renderProcessingTimeInput() {
    const { fields } = this.props
    const lables = {
      failed: '战败日期',
      invalid: '失效日期',
      completed: '成交日期',
    }
    const label = lables[fields.state.value]

    if (!label) return null

    return (
      <FormItem
        {...formItemLayout}
        label={label}
        required field={fields.processingTime}
      >
        <Datepicker {...fields.processingTime} />
      </FormItem>
    )
  }

  renderNextProcessTimeInput() {
    const { fields, intentionLevelsById } = this.props
    const min = moment().toDate()

    if (!['processing', 'hall_consignment', 'online_consignment'].includes(fields.state.value)) { // eslint-disable-line
      return null
    }

    const levelId = fields.intentionLevelId.value
    const level = intentionLevelsById[levelId]

    let max
    if (level) {
      max = moment().add(level.timeLimitation, 'days').toDate()
    }

    return (
      <FormItem
        {...formItemLayout}
        label="下次跟进："
        required field={fields.processingTime}
      >
        <Datepicker min={min} max={max} {...fields.processingTime} />
      </FormItem>
    )
  }

  render() {
    const {
      intention,
      fields,
      carsById
    } = this.props

    return (
      <AForm>
        <h5>本次跟进结果</h5>

        <Row>
          <Col span="12">
            <FormItem {...firstColLayout} label="跟进结果：" required field={fields.intentionType} >
              <Select
                items={stateOptions[intention.intentionType]}
                {...fields.state}
              />
            </FormItem>
          </Col>
          {
            ['processing', 'interviewed', 'completed'].includes(fields.state.value) &&
              <Col span="12" pull="1">
                <FormItem {...secondColLayout} label="客户级别：" >
                  <IntentionLevelSelect {...fields.intentionLevelId} />
                </FormItem>
              </Col>
          }
        </Row>

        {
          ['hall_consignment', 'online_consignment'].includes(fields.state.value) &&
            <FormItem {...formItemLayout} label="寄卖日期：">
              <Datepicker format="date" {...fields.consignedAt} />
            </FormItem>
        }

        {this.renderProcessingTimeInput()}

        {
          fields.state.value === 'failed' &&
            <FormItem
              {...formItemLayout}
              label="战败原因："
              required field={fields.intentionPushFailReasonId}
            >
              <DefeatReasonSelect {...fields.intentionPushFailReasonId} />
            </FormItem>
        }

        {
          fields.state.value === 'interviewed' &&
            <FormItem
              {...formItemLayout}
              label="预约时间："
              required field={fields.interviewedTime}
            >
              <Datepicker format="datetime" {...fields.interviewedTime} />
            </FormItem>
        }

        {this.renderNextProcessTimeInput()}

        <h5>本次跟进详情</h5>

        <SeekCompleteDetail
          intention={intention}
          fields={fields}
          formItemLayout={formItemLayout}
          carsById={carsById}
          handleSeekingCarsEdit={this.handleSeekingCarsEdit('single')}
        />

        {
          ['processing', 'interviewed'].includes(fields.state.value) &&
            <FormItem
              {...formItemLayout}
              label={`是否${intention.intentionType === 'seek' ? '到店' : '评估实车'}：`}
            >
              <RadioGroup {...fields.checked}>
                <Radio key="a" value>是</Radio>
                <Radio key="b" value={false}>否</Radio>
              </RadioGroup>
            </FormItem>
        }

        {
          intention.intentionType === 'seek' &&
          ['processing', 'interviewed'].includes(fields.state.value) &&
          fields.checked.value &&
            <SeekingCars
              handleSeekingCarsEdit={this.handleSeekingCarsEdit('multi')}
              carsById={carsById}
              {...fields.carIds}
            />
        }

        {
          intention.intentionType === 'sale' && fields.checked.value &&
            <FormItem
              {...formItemLayout}
              label="评估价格："
              required field={fields.estimatedPriceWan}
            >
              <NumberInput {...fields.estimatedPriceWan} addonAfter="万元" />
            </FormItem>
        }

        <FormItem {...formItemLayout} label="跟进说明：" required field={fields.note}>
          <Textarea rows={4} {...fields.note} className="ant-input ant-input-lg" />
        </FormItem>
      </AForm>
    )
  }
}

function SeekCompleteDetail({
  intention, fields, formItemLayout,
  carsById, handleSeekingCarsEdit }) {
  if (intention.intentionType === 'seek' && fields.state.value === 'completed') {
    const carId = fields.closingCarId.value
    const handleChange = (ids) => {
      let id
      if (ids && ids.length > 0) {
        id = ids[0]
      }
      fields.closingCarId.onChange(id)
    }
    const closingCarInput = fields.manually.value ?
      <FormItem
        {...formItemLayout}
        label="成交车辆："
        required field={fields.closingCarName}
      >
        <Input {...fields.closingCarName} />
      </FormItem> :
      <Row>
        <Col offset="4" style={{ paddingBottom: '20px' }}>
          <SeekingCarsModal handleSelect={handleChange} selectedIds={[carId]} />
          {carId && <CarItem key={carId} car={carsById[carId]} />}
          <Button
            type="primary"
            onClick={handleSeekingCarsEdit}
          >
            选择成交车辆
          </Button>
        </Col>
      </Row>
    return (
      <div>
        <FormItem {...formItemLayout} label="手动输入车辆" >
          <RadioGroup {...fields.manually} value={fields.manually.value || false}>
            <Radio key="a" value>是</Radio>
            <Radio key="b" value={false}>否</Radio>
          </RadioGroup>
        </FormItem>
        {closingCarInput}
        <FormItem
          {...formItemLayout}
          label="定金："
          required field={fields.depositWan}
        >
          <NumberInput {...fields.depositWan} addonAfter="万元" />
        </FormItem>
        <FormItem
          {...formItemLayout}
          label="成交价格："
          required field={fields.closingCostWan}
        >
          <NumberInput {...fields.closingCostWan} addonAfter="万元" />
        </FormItem>
      </div>
    )
  }

  return false
}
