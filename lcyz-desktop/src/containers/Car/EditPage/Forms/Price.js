import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import styles from './Form.scss'
import { Element } from 'react-scroll'

function mapStateToProps(state) {
  return {
    recommendedPrice: state.styles.recommendedPrice
  }
}

const fields = [
  'car.showPriceWan', 'car.onlinePriceWan', 'car.salesMinimunPriceWan',
  'car.managerPriceWan', 'car.allianceMinimunPriceWan', 'car.newCarGuidePriceWan',
  'car.newCarAdditionalPriceWan', 'car.newCarDiscount', 'car.newCarFinalPriceWan'
]

@connect(mapStateToProps)
@formOptimize(fields)
class Price extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    recommendedPrice: PropTypes.object,
  }

  render() {
    const formItemLayout = {
      labelCol: { span: 8 },
      wrapperCol: { span: 15 },
    }

    const {
      showPriceWan, onlinePriceWan, salesMinimunPriceWan,
      newCarGuidePriceWan, newCarAdditionalPriceWan, newCarDiscount, newCarFinalPriceWan
    } = this.props.fields.car

    const { recommendedPrice } = this.props
    let recommendedPriceInfo = null
    if (recommendedPrice) {
      const minimumPrice = +(recommendedPrice.minimumPrice / 10000).toFixed(2)
      if (recommendedPrice.city + '' !== '') {
        recommendedPriceInfo = `${recommendedPrice.city}最低新车价：${minimumPrice}万`
      }
    }

    return (
      <Element name="price" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>定价信息</div>
        <Row>
          <Col span="6">
            <FormItem {...formItemLayout} field={showPriceWan} label="展厅标价：">
              <NumberInput addonAfter="万元" {...showPriceWan} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem {...formItemLayout} field={onlinePriceWan} label="网络标价：">
              <NumberInput addonAfter="万元" {...onlinePriceWan} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem {...formItemLayout} field={salesMinimunPriceWan} label="销售底价：">
              <NumberInput addonAfter="万元" {...salesMinimunPriceWan} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="6">
            <FormItem {...formItemLayout} field={newCarGuidePriceWan} label="新车指导价：">
              <NumberInput addonAfter="万元" {...newCarGuidePriceWan} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem
              {...formItemLayout}
              field={newCarAdditionalPriceWan}
              label="新车加价："
              help={recommendedPriceInfo}
            >
              <NumberInput addonAfter="万元" {...newCarAdditionalPriceWan} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem {...formItemLayout} label="或优惠：">
              <NumberInput addonAfter="%" {...newCarDiscount} />
            </FormItem>
          </Col>
          <Col span="6">
            <FormItem {...formItemLayout} field={newCarFinalPriceWan} label="新车完税价：">
              <NumberInput addonAfter="万元" {...newCarFinalPriceWan} />
            </FormItem>
          </Col>
        </Row>
      </Element>
    )
  }
}

Price.fields = fields

export default Price
