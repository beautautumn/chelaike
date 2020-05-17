import React from 'react'
import { Modal, Form, Input, Checkbox } from 'antd'
import layoutConfig from '../../../utils/formItemLayoutFacory'
const FormItem = Form.Item
const CheckboxGroup = Checkbox.Group

export default Form.create()(props => {
  const { visible, onCancel, onOk, form, confirmLoading, authorities } = props
  const { getFieldDecorator } = form
  const authorityOptions = authorities.map(auth => ({ label: auth, value: auth }))

  getFieldDecorator('id');
  return (
    <Modal title="角色"
      visible={visible}
      confirmLoading={confirmLoading}
      onOk={onOk}
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form>
        <FormItem {...layoutConfig(6, 14)} label="名称">
          {getFieldDecorator('name', {
            rules: [{ required: true, message: '请输入角色名称' }],
          })(
            <Input />
          )}
        </FormItem>
        <FormItem {...layoutConfig(6, 14)} label="权限">
          {getFieldDecorator('authorities', {})(
            <CheckboxGroup options={authorityOptions} />
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
