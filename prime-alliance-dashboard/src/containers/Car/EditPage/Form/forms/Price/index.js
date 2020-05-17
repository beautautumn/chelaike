import React, { PropTypes } from 'react'
import { connect } from 'react-redux'
import Style from 'models/style'
import { Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import { Element } from 'react-scroll'
import { compose } from 'redux'
import { isBlank } from 'utils'
import styles from '../../style.scss'

function Price(props) {
  const formItemLayout = {
    labelCol: { span: 8 },
    wrapperCol: { span: 15 },
  }

  const {
    showPriceWan, onlinePriceWan, salesMinimunPriceWan,
    managerPriceWan, allianceMinimunPriceWan, newCarGuidePriceWan,
    newCarAdditionalPriceWan, newCarDiscount, newCarFinalPriceWan,
  } = props.fields.car

  const { recommendedPrice } = props
  let recommendedPriceInfo = null
  if (recommendedPrice) {
    const minimumPrice = +(recommendedPrice.minimumPrice / 10000).toFixed(2)
    if (!isBlank(recommendedPrice.city)) {
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
      </Row>

      <Row>
        <Col span="6">
          <FormItem {...formItemLayout} field={salesMinimunPriceWan} label="销售底价：">
            <NumberInput addonAfter="万元" {...salesMinimunPriceWan} />
          </FormItem>
        </Col>
        <Col span="6">
          <FormItem {...formItemLayout} field={managerPriceWan} label="经理价：">
            <NumberInput addonAfter="万元" {...managerPriceWan} />
          </FormItem>
        </Col>
        <Col span="6">
          <FormItem {...formItemLayout} field={allianceMinimunPriceWan} label="联盟底价：">
            <NumberInput addonAfter="万元" placeholder="不填则等于销售底价" {...allianceMinimunPriceWan} />
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

const fields = [
  'car.showPriceWan', 'car.onlinePriceWan', 'car.salesMinimunPriceWan',
  'car.managerPriceWan', 'car.allianceMinimunPriceWan', 'car.newCarGuidePriceWan',
  'car.newCarAdditionalPriceWan', 'car.newCarDiscount', 'car.newCarFinalPriceWan',
]

function mapStateToProps(_state) {
  return {
    recommendedPrice: Style.getState().recommendedPrice,
  }
}

Price.fields = fields

Price.propTypes = {
  fields: PropTypes.object.isRequired,
  recommendedPrice: PropTypes.object,
}

export default compose(
  connect(mapStateToProps),
  formOptimize(fields)
)(Price)

