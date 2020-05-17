import React, { Component, PropTypes } from 'react'
import { Row, Col, Input } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem, Datepicker } from 'components'
import { formOptimize } from 'decorators'
import styles from '../../EditModal.scss'

const fields = [
  'currentPlateNumber',
  'transferRecevier',
  'transferRecevierIdcard',
  'estimatedArchivedAt',
  'estimatedTransferredAt',
  'transferFeeYuan'
]

@formOptimize(fields)
class CurrentInfo extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    formItemLayout: PropTypes.object.isRequired
  }

  render() {
    const { formItemLayout, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>现车信息</div>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="现车牌：">
              <Input {...fields.currentPlateNumber} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="现车主：">
              <Input {...fields.transferRecevier} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="现车主证件号：">
              <Input {...fields.transferRecevierIdcard} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="提档预计完成：">
              <Datepicker {...fields.estimatedArchivedAt} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="落户预计完成：">
              <Datepicker {...fields.estimatedTransferredAt} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="过户费用：">
              <NumberInput addonAfter="元" {...fields.transferFeeYuan} />
            </FormItem>
          </Col>
        </Row>
      </div>
    )
  }
}

CurrentInfo.fields = fields

export default CurrentInfo
