import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Row, Col, Input, Button, Table } from 'antd'
import { NumberInput } from '@prime/components'
import { Datepicker, UserSelect } from 'components'
import date from 'helpers/date'
const FormItem = AForm.Item

@reduxForm({
  form: 'paymentAndReceiptModalEditForFinance',
  fields: ['carFees'],
})
export default class Form extends Component {
  static propTypes = {
    record: PropTypes.object.isRequired,
    category: PropTypes.string.isRequired,
    fields: PropTypes.object.isRequired,
    userById: PropTypes.object.isRequired,
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
    validate('userId', errors)
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

  cateName = () => (this.props.category === 'payment' ? '付款' : '收款')

  price = (fees) => (fees ? `${fees} 万元` : '-')

  render() {
    const { record, fields, category, userById } = this.props

    const singleItemLayout = {
      labelCol: { span: 3 },
      wrapperCol: { span: 20 }
    }

    const formItemLayout = {
      labelCol: { span: 9 },
      wrapperCol: { span: 14 }
    }

    const columns = [{
      title: `${this.cateName()}人`,
      dataIndex: 'userId',
      render(text) { return userById[text].name }
    }, {
      title: `${this.cateName()}日期`,
      dataIndex: 'feeDate',
      render(text) { return date(text) }
    }, {
      title: `本次${this.cateName()}`,
      dataIndex: 'amount',
      render(text) { return `${text} 万元` }
    }, {
      title: `${this.cateName()}说明`,
      dataIndex: 'note',
    }, {
      title: '删除',
      key: 'operation',
      render: (text, fee, index) => (<a onClick={this.handleFeeDelete(index)}>删除</a>)
    }]

    const dataSource = fields.carFees.value.filter(fee => !fee._delete) // eslint-disable-line

    const shouldTotalFees = category === 'payment' ?
                            record.acquisitionPriceWan : record.closingCostWan

    const totalFees = dataSource.reduce((pre, curr) => pre + Number(curr.amount), 0)

    const restFees = shouldTotalFees - totalFees

    return (
      <AForm horizontal>
        <FormItem {...singleItemLayout} label="车辆名称：">
          <p className="ant-form-text">{record.name}</p>
        </FormItem>

        <Row gutter={16}>
          <Col span="8">
            <FormItem {...formItemLayout} label={`应${this.cateName()}`} >
              <p className="ant-form-text">
                {this.price(shouldTotalFees)}
              </p>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem {...formItemLayout} label={`已${this.cateName()}`} >
              <p className="ant-form-text">
                {this.price(totalFees)}
              </p>
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem {...formItemLayout} label="余款" >
              <p className="ant-form-text">
                {this.price(restFees)}
              </p>
            </FormItem>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span="8">
            <FormItem
              {...formItemLayout}
              {...this.state.errors.itemName}
              label={`${this.cateName()}人`}
              required
            >
              <UserSelect
                value={this.state.fee.userId}
                onChange={this.handleFeeChange('userId')}
                as="financer"
              />
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem
              {...formItemLayout}
              {...this.state.errors.feeDate}
              label={`${this.cateName()}日期`}
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
              label={`本次${this.cateName()}`}
              required
            >
              <NumberInput
                addonAfter="万元"
                value={this.state.fee.amount}
                onChange={this.handleFeeChange('amount')}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="22">
            <FormItem {...singleItemLayout} label={`${this.cateName()}说明`} >
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
          footer={() => `付款合计  ${totalFees} 万元`}
        />
      </AForm>
    )
  }
}
