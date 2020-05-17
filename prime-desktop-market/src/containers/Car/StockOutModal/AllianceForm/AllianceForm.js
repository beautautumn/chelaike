import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form, Input } from 'antd'
import { NumberInput } from '@prime/components'
import {
  FormItem,
  Datepicker,
  UserSelect,
  AllianceSelectGroup,
  AllianceSelect,
  CompanySelect,
  AllyShopSelect,
} from 'components'
import { errorFocus, autoId } from 'decorators'
import { price } from 'helpers/car'
import validation from './validation'
import MicroContract from 'containers/Car/DetailPage/Details/MicroContract'

@reduxForm({
  form: 'stockOutAllianceInventory',
  fields: [
    'stockOutInventoryType', 'completedAt', 'sellerId',
    'closingCostWan', 'depositWan', 'remainingMoneyWan',
    'note', 'allianceId', 'companyId', 'toShopId'
  ],
  validate: validation
})
@errorFocus
@autoId
export default class AllianceForm extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    autoId: PropTypes.func.isRequired,
    showMicroContract: PropTypes.bool.isRequired,
  }

  allianceOnChange = (value, convention, name) => {
    const { fields } = this.props

    fields.allianceId.onChange(value)
    fields.note.onChange(convention)
    this.allianceName = name
  }

  companyOnChange = (value, name) => {
    const { fields } = this.props

    fields.companyId.onChange(value)
    this.companyName = name
  }


  render() {
    const { car, fields, autoId, showMicroContract, currentUser, transfersById } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    if (showMicroContract) {
      const microContract = {
        allianceName: this.allianceName,
        fromCompanyName: currentUser.company.name,
        toCompanyName: this.companyName,
        completedAt: fields.completedAt.value,
        closingCostWan: fields.closingCostWan.value,
        depositWan: fields.depositWan.value,
        remainingMoneyWan: fields.remainingMoneyWan.value,
        note: fields.note.value,
      }

      const fakeCar = { ...car, microContract }

      return (
        <MicroContract car={fakeCar} transfersById={transfersById} />
      )
    }

    return (
      <Form horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>

        <FormItem {...formItemLayout} label="联盟底价：">
          <p className="ant-form-text">{price(car.allianceMinimunPriceWan, '万元')}</p>
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="成交价格："
          field={fields.closingCostWan}
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.closingCostWan} />
        </FormItem>

        <FormItem
          key="depositWan"
          id={autoId()}
          required
          {...formItemLayout}
          label="定金："
          field={fields.depositWan}
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.depositWan} />
        </FormItem>

        <FormItem
          key="remainingMoneyWan"
          id={autoId()}
          required
          {...formItemLayout}
          label="余款："
          field={fields.remainingMoneyWan}
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.remainingMoneyWan} />
        </FormItem>

        <AllianceSelectGroup>
          <div>
            <FormItem
              id={autoId()}
              required
              {...formItemLayout}
              label="所属联盟："
              field={fields.allianceId}
            >
              <AllianceSelect
                id={autoId()}
                {...fields.allianceId}
                onChange={this.allianceOnChange}
              />
            </FormItem>

            <FormItem
              id={autoId()}
              required
              {...formItemLayout}
              label="出库到："
              field={fields.companyId}
            >
              <CompanySelect
                id={autoId()}
                {...fields.companyId}
                exclude={car.companyId}
                onChange={this.companyOnChange}
              />
            </FormItem>

            <FormItem
              id={autoId()}
              required
              {...formItemLayout}
              label="归属分店："
              field={fields.toShopId}
            >
              <AllyShopSelect
                id={autoId()}
                {...fields.toShopId}
              />
            </FormItem>
          </div>
        </AllianceSelectGroup>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          label="成交员工："
          field={fields.sellerId}
        >
          <UserSelect id={autoId()} as="all" {...fields.sellerId} />
        </FormItem>

        <FormItem
          id={autoId()}
          required
          {...formItemLayout}
          required
          label="成交日期："
          field={fields.completedAt}
        >
          <Datepicker id={autoId()} {...fields.completedAt} />
        </FormItem>

        <FormItem id={autoId()} {...formItemLayout} label="备注：">
          <Input id={autoId()} type="textarea" rows="4" {...fields.note} />
        </FormItem>
      </Form>
    )
  }
}
