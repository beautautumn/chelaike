import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Row, Col, Input, Button, Table } from 'antd'
import { NumberInput } from '@prime/components'
import { Select, Datepicker } from 'components'
import date from 'helpers/date'
import validation from './validation'
const FormItem = AForm.Item

@reduxForm({
  form: 'costAndBenefitEditForFinance',
  fields: ['carFees'],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    record: PropTypes.object.isRequired,
    category: PropTypes.string.isRequired,
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      fee: {},
      errors: {},
    }
  }

  handleFeeChange = (fieldName) => (event) => {
    const value = event.target ? event.target.value : event
    this.setState({ fee: { ...this.state.fee, [fieldName]: value } })
  }

  handleAddFee = () => {
    const fee = this.state.fee
    const errors = { hasError: false }
    const validate = (field, errors) => {
      errors[field] = fee[field] ? {} : { validateStatus: 'error', help: '不允许为空' }
      if (!fee[field]) errors.hasError = true
    }
    validate('itemName', errors)
    validate('feeDate', errors)
    validate('amount', errors)
    this.setState({ errors })

    if (!errors.hasError) {
      const { fields } = this.props
      const value = [...fields.carFees.value, fee]
      fields.carFees.onChange(value)
      this.setState({ fee: {} })
    }
  }

  handleFeeDelete = index => () => {
    const { fields } = this.props
    const value = fields.carFees.value.reduce((all, fee, currentIndex) => {
      if (currentIndex !== index) {
        all.push(fee)
      }
      return all
    }, [])
    const deletedFee = fields.carFees.value[index]
    if (deletedFee.id) {
      deletedFee._delete = true // eslint-disable-line
      value.push(deletedFee)
    }
    fields.carFees.onChange(value)
  }


  render() {
    const { record, category, enumValues, fields } = this.props

    const singleItemLayout = {
      labelCol: { span: 3 },
      wrapperCol: { span: 20 }
    }

    const formItemLayout = {
      labelCol: { span: 9 },
      wrapperCol: { span: 14 }
    }

    const columns = [{
      title: '费用名称',
      dataIndex: 'itemName',
      render(text) { return enumValues.finance_car_fee[category][text] }
    }, {
      title: '费用日期',
      dataIndex: 'feeDate',
      render(text) { return date(text) }
    }, {
      title: '费用',
      dataIndex: 'amount',
      render(text) { return `${text}元` }
    }, {
      title: '费用说明',
      dataIndex: 'note',
    }, {
      title: '删除',
      key: 'operation',
      render: (text, fee, index) => (<a onClick={this.handleFeeDelete(index)}>删除</a>)
    }]

    const dataSource = fields.carFees.value.filter(fee => !fee._delete) // eslint-disable-line

    const totalFees = dataSource.reduce((pre, curr) => pre + Number(curr.amount), 0)

    return (
      <AForm horizontal>
        <FormItem {...singleItemLayout} label="车辆名称：">
          <p className="ant-form-text">{record.name}</p>
        </FormItem>

        <Row gutter={16}>
          <Col span="8">
            <FormItem
              {...formItemLayout}
              {...this.state.errors.itemName}
              label="费用名称"
              required
            >
              <Select
                items={enumValues.finance_car_fee[category]}
                value={this.state.fee.itemName}
                onChange={this.handleFeeChange('itemName')}
              />
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem
              {...formItemLayout}
              {...this.state.errors.feeDate}
              label="费用日期"
              required
            >
              <Datepicker
                value={this.state.fee.feeDate}
                onChange={this.handleFeeChange('feeDate')}
              />
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem
              {...formItemLayout}
              {...this.state.errors.amount}
              label="费用"
              required
            >
              <NumberInput
                addonAfter="元"
                value={this.state.fee.amount}
                onChange={this.handleFeeChange('amount')}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="22">
            <FormItem {...singleItemLayout} label="费用说明：">
              <Input
                type="textarea"
                value={this.state.fee.note}
                onChange={this.handleFeeChange('note')}
              />
            </FormItem>
          </Col>
          <Col span="2">
            <Button onClick={this.handleAddFee}>添加</Button>
          </Col>
        </Row>

        <Table
          columns={columns}
          dataSource={dataSource}
          size="small"
          pagination={false}
          footer={() => (
            <div>
              <div>付款合计 {totalFees.toFixed(2)}元</div>
              {fields.carFees.touched && !fields.carFees.valid &&
                <div style={{ color: 'red' }}>{fields.carFees.error}</div>
              }
            </div>)}
        />
      </AForm>
    )
  }
}
