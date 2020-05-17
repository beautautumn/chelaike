import React, { Component, PropTypes } from 'react'
import { Row, Col } from 'antd'
import { Select, Datepicker, FormItem } from 'components'
import { formOptimize } from 'decorators'
import styles from '../EditModal.scss'

const fields = ['state', 'transferredAt']

@formOptimize(fields)
class State extends Component {
  static propTypes = {
    formItemLayout: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired
  }

  render() {
    const { formItemLayout, car, fields, enumValues } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>牌证状态</div>
        <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 21 }} label="车架号：">
          <p className="ant-form-text">{car.vin}</p>
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="手续状态：">
              <Select
                items={enumValues.transfer_record.state}
                prompt="选择状态"
                {...fields.state}
              />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="落户完成时间：">
              <Datepicker id="transferredAt" {...fields.transferredAt} />
            </FormItem>
          </Col>
        </Row>
      </div>
    )
  }
}

State.fields = fields

export default State
