import React from 'react';
import { Modal, Form, Select, Input, Radio, Checkbox } from 'antd';
import { NumberSelect } from 'components';
import layoutConfig from '../../../utils/formItemLayoutFacory';
const FormItem = Form.Item;
const Option = Select.Option;
const RadioGroup = Radio.Group;
const CheckboxGroup = Checkbox.Group;

class UserModal extends React.Component {
  render() {
    const {
      visible,
      onCancel,
      onOk,
      form,
      confirmLoading,
      authorities,
      roles,
      funderCompanys,
      userTypes
    } = this.props;
    const { getFieldDecorator } = form;
    const authorityType = form.getFieldValue('authorityType') || 'role';
    const type = form.getFieldValue('type');
    const authorityOptions = authorities.map(auth => ({
      label: auth,
      value: auth
    }));

    getFieldDecorator('id');
    getFieldDecorator('easyLoanAuthorityRoleId');
    getFieldDecorator('type');
    getFieldDecorator('typeId');
    getFieldDecorator('authorities');
    return (
      <Modal
        title="员工"
        visible={visible}
        confirmLoading={confirmLoading}
        onOk={onOk}
        onCancel={onCancel}
        maskClosable={false}
      >
        <Form>
          <FormItem {...layoutConfig(6, 14)} label="姓名">
            {getFieldDecorator('name', {
              rules: [{ required: true, message: '请输入员工名称' }]
            })(<Input />)}
          </FormItem>
          <FormItem {...layoutConfig(6, 14)} label="电话">
            {getFieldDecorator('phone', {
              rules: [
                { required: true, message: '请输入员工电话' },
                { len: 11, message: '无效的手机号码（需要11位数字）' }
              ]
            })(<Input />)}
          </FormItem>
          <FormItem {...layoutConfig(6, 14)} label="员工类型">
            {getFieldDecorator('type', {
              rules: [{ required: true, message: '请选择员工类型' }],
              initialValue: 'sp'
            })(
              <Select placeholder="请选择员工类型">
                {userTypes &&
                  userTypes.map(users => (
                    <Option key={users.type} value={users.type}>
                      {users.name}
                    </Option>
                  ))}
              </Select>
            )}
          </FormItem>
          {type === 'funder' && (
            <FormItem {...layoutConfig(6, 14)} label="所属资金方">
              {getFieldDecorator('typeId', {
                rules: [{ required: true, message: '请选择资金方' }]
              })(
                <Select placeholder="请选择资金方">
                  {funderCompanys &&
                    funderCompanys.map(funder => (
                      <Option key={funder.id} value={funder.id}>
                        {funder.name}
                      </Option>
                    ))}
                </Select>
              )}
            </FormItem>
          )}
          <FormItem {...layoutConfig(6, 14)} label="权限类型">
            {getFieldDecorator('authorityType', {
              initialValue: authorityType
            })(
              <RadioGroup>
                <Radio value="role">关联角色</Radio>
                <Radio value="customer">单独设置</Radio>
              </RadioGroup>
            )}
          </FormItem>
          {authorityType === 'role' && (
            <FormItem {...layoutConfig(6, 14)} label="角色">
              {getFieldDecorator('easyLoanAuthorityRoleId', {})(
                <NumberSelect>
                  {roles.map(r => <Option key={r.id}>{r.name}</Option>)}
                </NumberSelect>
              )}
            </FormItem>
          )}
          {authorityType === 'customer' && (
            <FormItem {...layoutConfig(6, 14)} label="权限">
              {getFieldDecorator('authorities', {})(
                <CheckboxGroup options={authorityOptions} />
              )}
            </FormItem>
          )}
        </Form>
      </Modal>
    );
  }
}

export default Form.create()(UserModal);
