import React, { Component, PropTypes } from 'react'
import { Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import Textarea from 'react-textarea-autosize'
import { FormItem, UserSelect, Datepicker } from 'components'
import { formOptimize } from 'decorators'
import styles from '../../EditModal.scss'

const fields = [
  'userId',
  'compulsoryInsuranceEndAt',
  'annualInspectionEndAt',
  'commercialInsuranceEndAt',
  'commercialInsuranceAmountYuan',
  'note'
]

@formOptimize(fields)
class OtherInfo extends Component {
  static propTypes = {
    formItemLayout: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired
  }

  render() {
    const { formItemLayout, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>其他信息</div>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="销售员：">
              <UserSelect {...fields.userId} as="all" />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="交强险到期时间：">
              <Datepicker {...fields.compulsoryInsuranceEndAt} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="年审到期时间：">
              <Datepicker {...fields.annualInspectionEndAt} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="商业险到期时间：">
              <Datepicker {...fields.commercialInsuranceEndAt} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="商业险金额：">
              <NumberInput addonAfter="元" {...fields.commercialInsuranceAmountYuan} />
            </FormItem>
          </Col>
        </Row>

        <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 21 }} label="补充说明：">
          <Textarea className="ant-input ant-input-lg" rows={4} {...fields.note} />
        </FormItem>
      </div>
    )
  }
}

OtherInfo.fields = fields

export default OtherInfo
