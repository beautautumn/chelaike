import React, { Component, PropTypes } from 'react'
import { Row, Col, Radio } from 'antd'
import Textarea from 'react-textarea-autosize'
import { FormItem, RadioGroup, UserSelect, Datepicker } from 'components'
import { formOptimize } from 'decorators'
import styles from '../../EditModal.scss'

const fields = [
  'userId',
  'inspectionState',
  'compulsoryInsuranceEndAt',
  'annualInspectionEndAt',
  'note',
]

@formOptimize(fields)
class OtherInfo extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    formItemLayout: PropTypes.object.isRequired
  }

  render() {
    const { formItemLayout, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>其他信息</div>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="收购员：">
              <UserSelect {...fields.userId} as="all" />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="验车状态：">
              <RadioGroup {...fields.inspectionState}>
                <Radio value="valid">可验车</Radio>
                <Radio value="invalid">不可验车</Radio>
              </RadioGroup>
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="交强险到期时间：">
              <Datepicker {...fields.compulsoryInsuranceEndAt} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="年审到期时间：">
              <Datepicker {...fields.annualInspectionEndAt} />
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
