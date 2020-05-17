import React from 'react'
import { Modal, Form, Select, Input, Row, Col } from 'antd'
import layoutConfig from '../../../utils/formItemLayoutFacory'
import styles from './StatusChangeModal.scss'
const FormItem = Form.Item
const Option = Select.Option

export default Form.create()(props => {
  const { visible, onCancel, onOk, form, loanStatus, confirmLoading } = props
  const { getFieldDecorator } = form
  getFieldDecorator('id')
  getFieldDecorator('totalCarValuationAmountWan')
  getFieldDecorator('estimateBorrowAmountWan')
  getFieldDecorator('singleCarRate')
  return (
    <Modal title="修改借款状态"
      visible={visible}
      confirmLoading={confirmLoading}
      onOk={onOk}
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form>
        <Row className={styles.loanInfo}>
          <Col span={6} offset={3}>
            <label>
              申请金额：
            </label>
            <span>{form.getFieldValue('estimateBorrowAmountWan')}万</span>
          </Col>
          <Col span={6}>
            <label>
              评估价值：
            </label>
            <span>{form.getFieldValue('totalCarValuationAmountWan')}万</span>
          </Col>
          <Col span={6}>
            <label>
              借款比例：
            </label>
            <span>{form.getFieldValue('singleCarRate')}%</span>
          </Col>
        </Row>
        <FormItem {...layoutConfig(6, 14)} label="借款状态">
          {getFieldDecorator('state', {
            rules: [{ required: true, message: '请选择修改状态' }],
          })(
            <Select>
              {Object.getOwnPropertyNames(loanStatus).map(key => (
                <Option key={key}>{loanStatus[key]}</Option>
              ))}
            </Select>
          )}
        </FormItem>
        <FormItem {...layoutConfig(6, 14)} label="金额">
          {getFieldDecorator('borrowedAmountWan', {})(
            <Input style={{ width: '100%' }} addonAfter="万元"/>
          )}
        </FormItem>
        <FormItem {...layoutConfig(6, 14)} label="备注">
          {getFieldDecorator('note', {})(
            <Input type="textarea" placeholder="" autosize={{ minRows: 2, maxRows: 6 }} />
          )}
        </FormItem>
      </Form>
    </Modal>
  )
})
