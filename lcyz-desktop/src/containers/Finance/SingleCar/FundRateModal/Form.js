import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Row, Col, Table, Button } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem } from 'components'
import { autoId } from 'decorators'
import validation from './validation'
import date from 'helpers/date'

@reduxForm({
  form: 'inStockPriceEditForFinance',
  fields: ['fundRate', 'loanWan'],
  validate: validation
})
@autoId
export default class Form extends Component {
  static propTypes = {
    carName: PropTypes.string.isRequired,
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired,
    carFees: PropTypes.array.isRequired,
    handleReCompute: PropTypes.func.isRequired,
  }

  render() {
    const { carName, payment, fields, autoId, carFees, handleReCompute } = this.props

    const singleItemLayout = {
      labelCol: { span: 3 },
      wrapperCol: { span: 20 }
    }

    const formItemLayout = {
      labelCol: { span: 9 },
      wrapperCol: { span: 14 }
    }

    let gearing = ''
    if (!payment) {
      gearing = '-'
    } else if (!fields.loanWan.value) {
      gearing = '0 %'
    } else if (payment) {
      gearing = (fields.loanWan.value / payment * 100).toFixed(2) + ' %'
    }

    const columns = [{
      title: '月份',
      dataIndex: 'month',
      render(text, record) { return date(record.feeDate, 'short') }
    }, {
      title: '计算日期',
      dataIndex: 'feeDate',
      render(text) { return date(text) }
    }, {
      title: '当月费用',
      dataIndex: 'amount',
      render(text) { return `${text}元` }
    }]

    const dataSource = carFees

    const totalFees = dataSource.reduce((pre, curr) => pre + Number(curr.amount), 0)

    return (
      <AForm horizontal>
        <FormItem {...singleItemLayout} label="车辆名称：">
          <p className="ant-form-text">{carName}</p>
        </FormItem>

        <Row gutter={16}>
          <Col span="8">
            <FormItem
              id={autoId()}
              required
              {...formItemLayout}
              label="资金利率："
              field={fields.fundRate}
            >
              <NumberInput id={autoId()} addonAfter="％／月" {...fields.fundRate} />
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem
              id={autoId()}
              required
              {...formItemLayout}
              label="借贷资金："
              field={fields.loanWan}
            >
              <NumberInput id={autoId()} addonAfter="万" {...fields.loanWan} />
            </FormItem>
          </Col>
          <Col span="8">
            <FormItem {...formItemLayout} label="融资比例：">
              <p className="ant-form-text">{gearing}</p>
            </FormItem>
          </Col>
        </Row>

        <Button
          style={{ margin: '0 0 10px 0' }}
          type="primary"
          onClick={handleReCompute}
        >
          重计算
        </Button>

        <Table
          columns={columns}
          dataSource={dataSource}
          size="small"
          pagination={false}
          footer={() => (<div>资金费用合计 {totalFees.toFixed(2)}元</div>)}
        />
      </AForm>
    )
  }
}
