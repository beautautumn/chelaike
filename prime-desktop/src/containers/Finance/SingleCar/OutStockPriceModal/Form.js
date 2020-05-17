import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input } from 'antd'
import { NumberInput } from '@prime/components'
import {
  FormItem,
  Datepicker,
  UserSelect,
  MortgageCompanySelect,
} from 'components'
import { autoId } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'outStockPriceEditForFinance',
  fields: [
    'note', 'closingCostWan', 'completedAt', 'sellerId',
    'paymentType', 'depositWan', 'remainingMoneyWan',
    'downPaymentWan', 'loanAmountWan', 'mortgagePeriodMonths', 'mortgageFeeYuan',
    'foregiftYuan', 'transferFeeYuan', 'commissionYuan', 'otherFeeYuan',
    'mortgageCompanyId', 'invoiceFeeYuan',
  ],
  validate: validation
})
@autoId
export default class Form extends Component {
  static propTypes = {
    carName: PropTypes.string.isRequired,
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired
  }

  render() {
    const { carName, fields, autoId } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 15 }
    }

    let paymentType = ''
    if (fields.paymentType.value === 'cash') paymentType = '现金'
    if (fields.paymentType.value === 'mortgage') paymentType = '按揭'

    return (
      <AForm horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{carName}</p>
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="销售员："
          field={fields.sellerId}
        >
          <UserSelect id={autoId()} as="all" {...fields.sellerId} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="出库日期："
          field={fields.completedAt}
        >
          <Datepicker id={autoId()} {...fields.completedAt} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="出库价格："
          field={fields.closingCostWan}
        >
          <Input.Group>
            <NumberInput id={autoId()} addonAfter="万元" {...fields.closingCostWan} />
          </Input.Group>
        </FormItem>

        <FormItem {...formItemLayout} label="付款类型：">
          <p className="ant-form-text">{paymentType}</p>
        </FormItem>

        {fields.paymentType.value === 'cash' && [
          <FormItem
            key="depositWan"
            id={autoId()}
            {...formItemLayout}
            label="定金："
            field={fields.depositWan}
          >
            <NumberInput id={autoId()} addonAfter="万元" {...fields.depositWan} />
          </FormItem>,

          <FormItem
            key="remainingMoneyWan"
            id={autoId()}
            {...formItemLayout}
            label="余款："
            field={fields.remainingMoneyWan}
          >
            <NumberInput id={autoId()} addonAfter="万元" {...fields.remainingMoneyWan} />
          </FormItem>
        ]}


        {fields.paymentType.value === 'mortgage' && [
          <FormItem
            key="mortgageCompanyId"
            id={autoId()}
            required
            {...formItemLayout}
            label="按揭公司："
            field={fields.mortgageCompanyId}
          >
            <MortgageCompanySelect {...fields.mortgageCompanyId} />
          </FormItem>,

          <FormItem
            key="downPaymentWan"
            id={autoId()}
            required
            {...formItemLayout}
            label="首付款："
            field={fields.downPaymentWan}
          >
            <NumberInput id={autoId()} addonAfter="万元" {...fields.downPaymentWan} />
          </FormItem>,

          <FormItem
            key="loanAmountWan"
            id={autoId()}
            {...formItemLayout}
            label="贷款额度："
            field={fields.loanAmountWan}
          >
            <NumberInput id={autoId()} addonAfter="万元" {...fields.loanAmountWan} />
          </FormItem>,

          <FormItem key="mortgagePeriodMonths" id={autoId()} {...formItemLayout} label="按揭周期：">
            <NumberInput id={autoId()} addonAfter="个月" {...fields.mortgagePeriodMonths} />
          </FormItem>,

          <FormItem key="mortgageFeeYuan" id={autoId()} {...formItemLayout} label="按揭费用：">
            <NumberInput id={autoId()} addonAfter="元" {...fields.mortgageFeeYuan} />
          </FormItem>,

          <FormItem key="foregiftYuan" id={autoId()} {...formItemLayout} label="押金：">
            <NumberInput id={autoId()} addonAfter="元" {...fields.foregiftYuan} />
          </FormItem>,
        ]}

        <FormItem id={autoId()} {...formItemLayout} label="过户费用：">
          <NumberInput id={autoId()} addonAfter="元" {...fields.transferFeeYuan} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="佣金：">
          <NumberInput id={autoId()} addonAfter="元" {...fields.commissionYuan} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="开票费用：">
          <NumberInput id={autoId()} addonAfter="元" {...fields.invoiceFeeYuan} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="其他费用：">
          <NumberInput id={autoId()} addonAfter="元" {...fields.otherFeeYuan} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="调整说明：">
          <Input id={autoId()} type="textarea" rows="4" {...fields.note} />
        </FormItem>
      </AForm>
    )
  }
}
