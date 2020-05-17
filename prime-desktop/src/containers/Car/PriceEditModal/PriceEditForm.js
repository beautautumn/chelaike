import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { errorFocus, autoId } from 'decorators'
import { Form, Collapse, Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem } from 'components'
import { price } from 'helpers/car'

const { Panel } = Collapse

@reduxForm({
  form: 'carPrice',
  fields: [
    'showPriceWan', 'onlinePriceWan', 'salesMinimunPriceWan', 'managerPriceWan',
    'allianceMinimunPriceWan', 'yellowStockWarningDays', 'redStockWarningDays',
    'newCarGuidePriceWan', 'newCarAdditionalPriceWan', 'newCarDiscount', 'newCarFinalPriceWan',
  ],
})
@errorFocus
@autoId
export default class PriceEditForm extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired
  }

  render() {
    const { car, fields, autoId } = this.props

    const formItemLayout = {
      labelCol: { span: 5 },
      wrapperCol: { span: 14 },
    }

    const { costStatement } = car

    return (
      <Form horizontal>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>
        {car.costSum &&
          <FormItem {...formItemLayout} label="成本：">
            <Collapse>
              <Panel header={car.costSum.value + ' 万元'}>
                {costStatement && Object.keys(costStatement).map(key => (
                  <Row key={key}>
                    <Col span="10">{`${costStatement[key].name} :`}</Col>
                    <Col span="12" offset="2">
                      {price(costStatement[key].value, costStatement[key].unit)}
                    </Col>
                  </Row>
                ))}
              </Panel>
            </Collapse>
          </FormItem>
        }
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.showPriceWan}
          label="展厅标价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.showPriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.onlinePriceWan}
          label="网络标价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.onlinePriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.salesMinimunPriceWan}
          label="销售底价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.salesMinimunPriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.managerPriceWan}
          label="经理价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.managerPriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.allianceMinimunPriceWan}
          label="联盟底价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.allianceMinimunPriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.newCarGuidePriceWan}
          label="新车指导价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.newCarGuidePriceWan} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.newCarAdditionalPriceWan}
          label="新车加价："
        >
          <NumberInput id={autoId()} addonAfter="万元" {...fields.newCarAdditionalPriceWan} />
        </FormItem>
        <FormItem id={autoId()} {...formItemLayout} label="新车优惠：">
          <NumberInput id={autoId()} addonAfter="%" {...fields.newCarDiscount} />
        </FormItem>
        <FormItem
          id={autoId()}
          {...formItemLayout}
          field={fields.newCarFinalPriceWan}
          label="新车完税价："
        >
          <NumberInput id={autoId()} addonAfter="万" {...fields.newCarFinalPriceWan} />
        </FormItem>
        <FormItem id={autoId()} {...formItemLayout} label="黄色预警车龄：">
          <NumberInput id={autoId()} addonAfter="天" {...fields.yellowStockWarningDays} />
        </FormItem>
        <FormItem id={autoId()} {...formItemLayout} label="红色预警车龄：">
          <NumberInput id={autoId()} addonAfter="天" {...fields.redStockWarningDays} />
        </FormItem>
      </Form>
    )
  }
}
