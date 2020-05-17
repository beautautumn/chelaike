import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { Row, Col, Switch } from 'antd'
import Textarea from 'react-textarea-autosize'
import { Rating, FormItem } from 'components'
import { formOptimize } from 'decorators'
import { create as createWarranty } from 'redux/modules/warranties'
import { change as changeFieldValue } from 'redux-form'
import styles from './Form.scss'
import { Element } from 'react-scroll'

function mapDispatchToProps(dispatch) {
  return {
    ...bindActionCreators({
      createWarranty,
      changeFieldValue,
    }, dispatch, 'inStock')
  }
}

const fields = [
  'car.starRating', 'car.isFixedPrice', 'car.allowedMortgage', 'car.isSpecialOffer',
  'car.mortgageNote', 'car.sellingPoint', 'car.warrantyId', 'car.warrantyFeeYuan',
]

@connect(null, mapDispatchToProps)
@formOptimize(fields)
class Sales extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    createWarranty: PropTypes.func.isRequired,
    changeFieldValue: PropTypes.func.isRequired,
  }

  handleSubmitWarranty = (data) => {
    if (data && data.name) {
      this.props.createWarranty(data)
        .then((responseData) => {
          this.props.changeFieldValue('car', 'car.warrantyId', responseData.payload.result)
        })
    }
  }

  render() {
    const {
      starRating, isFixedPrice, allowedMortgage, mortgageNote,
      sellingPoint, isSpecialOffer
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

        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="按揭说明：">
          <Textarea rows={4} className="ant-input ant-input-lg" {...mortgageNote} />
        </FormItem>

        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="卖点描述：">
          <Textarea rows={4} className="ant-input ant-input-lg" {...sellingPoint} />
        </FormItem>
      </Element>
    )
  }
}

Sales.fields = fields

export default Sales
