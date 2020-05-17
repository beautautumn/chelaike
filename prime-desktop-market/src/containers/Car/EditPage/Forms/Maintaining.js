import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Row, Col, Switch } from 'antd'
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
  'car.maintain4s', 'car.hasMaintainHistory', 'car.newCarWarranty'
]

@connect(mapStateToProps)
@formOptimize(fields)
class Maintaining extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { maintain4s } = this.props.fields.car

    const formItemLayout = {
      labelCol: { span: 7 },
      wrapperCol: { span: 12 },
    }

    return (
      <Element name="maintaining" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>车辆保养</div>
        <Row>
          <Col span="13">
            <FormItem {...formItemLayout} label="是否4S店定期保养：">
              <Switch
                defaultChecked={false}
                checkedChildren="有"
                unCheckedChildren="无"
                {...maintain4s}
              />
            </FormItem>
          </Col>
        </Row>
      </Element>
    )
  }
}

Maintaining.fields = fields

export default Maintaining
