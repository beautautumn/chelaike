import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col, Radio, Switch } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import styles from './Form.scss'
import { Element } from 'react-scroll'

function mapStateToProps(state) {
  return {
    enumValues: state.enumValues,
  }
}

const fields = [
  'car.maintainMileage', 'car.hasMaintainHistory', 'car.newCarWarranty'
]

@connect(mapStateToProps)
@formOptimize(fields)
class Maintaining extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { enumValues } = this.props
    const { maintainMileage, hasMaintainHistory, newCarWarranty } = this.props.fields.car

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 },
    }

    return (
      <Element name="maintaining" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>车辆保养</div>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="保养里程：">
              <NumberInput addonAfter="万公里" {...maintainMileage} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="保养纪录：">
              <Switch
                defaultChecked={false}
                checkedChildren="有"
                unCheckedChildren="无"
                {...hasMaintainHistory}
              />
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="新车质保：">
              <Radio.Group
                {...newCarWarranty}
                onChange={event => newCarWarranty.onChange(event.target.value)}
              >
              {Object.keys(enumValues.car.new_car_warranty).reduce((accumulator, key) => {
                accumulator.push(
                  <Radio key={key} value={key}>{enumValues.car.new_car_warranty[key]}</Radio>
                )
                return accumulator
              }, [])}
              </Radio.Group>
            </FormItem>
          </Col>
        </Row>
      </Element>
    )
  }
}

Maintaining.fields = fields

export default Maintaining
