import React from 'react'
import { Modal, Form, Select, Input } from 'antd'
import layoutConfig from '../../../utils/formItemLayoutFacory'

const FormItem = Form.Item
const Option = Select.Option

export default Form.create()(props => {

  const { visible, onCancel, onOk, form, loanStatus, confirmLoading } = props
  const { getFieldDecorator } = form
  getFieldDecorator('id')
  return (
    <Modal title="修改换车状态"
      visible={visible}
      confirmLoading={confirmLoading}
      onOk={onOk}
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form>
        <FormItem {...layoutConfig(6, 14)} label="换车状态">
          {getFieldDecorator('state', {
            rules: [{ required: true, message: '请选择换车状态' }],
          })(
            <Select>
              {Object.getOwnPropertyNames(loanStatus).map(key => (
                <Option key={key}>{loanStatus[key]}</Option>
              ))}
            </Select>
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