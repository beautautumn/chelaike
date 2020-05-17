import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col, Switch } from 'antd'
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
  'car.newCarAdditionalPriceWan', 'car.newCarDiscount', 'car.newCarFinalPriceWan',
  'car.transferFeeIncluded'
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
      showPriceWan, onlinePriceWan, salesMinimunPriceWan, newCarGuidePriceWan,
      newCarFinalPriceWan, transferFeeIncluded,
    } = this.props.fields.car

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
            <FormItem labelCol={{ span: 12 }} wrapperCol={{ span: 12 }} label="是否包含过户费：">
              <Switch
                defaultChecked={false}
                checkedChildren="是"
                unCheckedChildren="否"
                {...transferFeeIncluded}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
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
