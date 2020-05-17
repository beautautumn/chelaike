import React, { Component, PropTypes } from 'react'
import { connect } from 'feeble/redux'
import { Row, Col, Input, Switch } from 'antd'
import { NumberInput } from '@prime/components'
import { Select, Rating, FormItem } from 'components'
import { formOptimize } from 'decorators'
import warranty from 'models/warranty'
import { change as changeFieldValue } from 'redux-form'
import { Element } from 'react-scroll'
import styles from '../../style.scss'

const fields = [
  'car.starRating', 'car.isFixedPrice', 'car.allowedMortgage', 'car.isSpecialOffer',
  'car.mortgageNote', 'car.sellingPoint', 'car.warrantyId', 'car.warrantyFeeYuan',
  'car.companyId',
]

@connect()
@formOptimize(fields)
class Sales extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  handleSubmitWarranty = (data) => {
    if (data && data.name) {
      this.props.dispatch(warranty.create(data))
        .then((responseData) => {
          this.props.dispatch(
            changeFieldValue('car', 'car.warrantyId', responseData.payload.result)
          )
        })
    }
  }

  render() {
    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 19 },
    }

    const { car } = this.props

    const {
      starRating, isFixedPrice, allowedMortgage, mortgageNote,
      sellingPoint, warrantyId, warrantyFeeYuan, isSpecialOffer,
    } = this.props.fields.car

    return (
      <Element name="sales" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>销售描述</div>

        <Row>
          <Col span="6">
            <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 15 }} label="车辆星级：">
              <Rating {...starRating} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 15 }} label="一口价：">
              <Switch
                defaultChecked={false}
                checkedChildren="是"
                unCheckedChildren="否"
                {...isFixedPrice}
              />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 15 }} label="可按揭：">
              <Switch
                defaultChecked={false}
                checkedChildren="是"
                unCheckedChildren="否"
                {...allowedMortgage}
              />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 15 }} label="特价车：">
              <Switch
                defaultChecked={false}
                checkedChildren="是"
                unCheckedChildren="否"
                {...isSpecialOffer}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="质保等级：">
              <Col span="21">
                <Select.Warranty {...warrantyId} query={car.companyId} />
              </Col>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="质保费用：">
              <NumberInput addonAfter="元" {...warrantyFeeYuan} />
            </FormItem>
          </Col>
        </Row>

        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="按揭说明：">
          <Input type="textarea" autosize rows={4} {...mortgageNote} />
        </FormItem>

        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="卖点描述：">
          <Input type="textarea" autosize rows={4} {...sellingPoint} />
        </FormItem>
      </Element>
    )
  }
}

Sales.fields = fields

export default Sales
