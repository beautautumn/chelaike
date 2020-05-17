import React from 'react';
import { Modal, Form, Input, Row, Col, Select } from 'antd';
import { CompanySelect } from 'components';
import layoutConfig from '../../../utils/formItemLayoutFacory';
import styles from './CreditModal.scss';
import pick from 'lodash/pick';

const FormItem = Form.Item;
const Option = Select.Option;
const TextArea = Input.TextArea;

export default Form.create()(props => {
  const {
    visible,
    onCancel,
    onOk,
    form,
    confirmLoading,
    funders,
    assignees
  } = props;
  const { getFieldDecorator, getFieldValue } = form;

  getFieldDecorator('id');
  getFieldDecorator('name');

  const id = getFieldValue('id');
  const name = getFieldValue('name');
  const modalTitle = id ? '修改授信车商' : '新增授信车商';
  const afterShopChanged = shop => {
    form.setFieldsValue(pick(shop, ['address', 'contactName', 'contactPhone']));
  };

  return (
    <Modal
      title={modalTitle}
      visible={visible}
      confirmLoading={confirmLoading}
      onOk={onOk}
      onCancel={onCancel}
      maskClosable={false}
    >
      <Form>
        {id ? (
          <FormItem
            {...layoutConfig(5, 12)}
            className={styles.companyName}
            label="授信商家"
          >
            <label>{name}</label>
            {getFieldDecorator('shopId', {})(<Input type="hidden" />)}
          </FormItem>
        ) : (
          <FormItem {...layoutConfig(5, 12)} label="授信商家">
            {getFieldDecorator('shopId', {
              rules: [{ required: true, message: '请选择商家' }]
            })(
              <CompanySelect
                placeholder="请输入商家关键字"
                afterChanged={afterShopChanged}
              />
            )}
          </FormItem>
        )}
        <FormItem {...layoutConfig(5, 12)} label="联系人">
          {getFieldDecorator('contactName', {
            rules: [{ required: true, message: '请填写联系人' }]
          })(<Input placeholder="请填写联系人" />)}
        </FormItem>
        <FormItem {...layoutConfig(5, 12)} label="电话">
          {getFieldDecorator('contactPhone', {
            rules: [{ required: true, message: '请填写联系电话' }]
          })(<Input placeholder="请填写联系电话" />)}
        </FormItem>
        <FormItem {...layoutConfig(5, 12)} label="地址">
          {getFieldDecorator('address', {
            rules: [{ required: true, message: '请填写地址' }]
          })(<TextArea placeholder="请填写地址" />)}
        </FormItem>
        <FormItem {...layoutConfig(5, 12)} label="归属业务员">
          {getFieldDecorator('assigneeId', {
            rules: [{ required: true, message: '请选择归属业务员' }]
          })(
            <Select placeholder="请选择归属业务员">
              {assignees.map(assignee => (
                <Option key={assignee.id} name={assignee.name}>
                  {assignee.name}
                </Option>
              ))}
            </Select>
          )}
        </FormItem>
        <Row>
          <Col span={12}>
            <FormItem
              {...layoutConfig(10, 12)}
              label="单车借款比例"
              className={styles.addonGroup}
            >
              {getFieldDecorator(`singleCarRate`, {
                rules: [
                  {
                    pattern: /^(?!0+(\.0+)?$)\d+(\.\d+)?$/,
                    message: '请输入数字'
                  }
                ]
              })(<Input placeholder="请输入数字" addonAfter="%" />)}
            </FormItem>
          </Col>
          <Col span={12}>
            <FormItem
              {...layoutConfig(10, 12)}
              label="总当前授信"
              className={styles.addonGroup}
            >
              {getFieldDecorator(`totalCurrentCreditWan`, {
                rules: [
                  {
                    pattern: /^(?!0+(\.0+)?$)\d+(\.\d+)?$/,
                    message: '请输入数字'
                  }
                ]
              })(<Input placeholder="请输入数字" addonAfter="万元" />)}
            </FormItem>
          </Col>
        </Row>
        {funders &&
          funders.map((f, i) => (
            <Row key={f.id}>
              <Col span={24} className={styles.funder}>
                {f.name}
                {getFieldDecorator(
                  `loanAccreditedRecordDtosList[${i}].funderCompany.id`,
                  {}
                )(<Input type="hidden" />)}
              </Col>
              <Col span={12}>
                <FormItem
                  {...layoutConfig(10, 12)}
                  label="最大授信额度"
                  className={styles.addonGroup}
                >
                  {getFieldDecorator(
                    `loanAccreditedRecordDtosList[${i}].limitAmountWan`,
                    {
                      rules: [
                        {
                          pattern: /^(?!0+(\.0+)?$)\d+(\.\d+)?$/,
                          message: '请输入数字'
                        }
                      ]
                    }
                  )(<Input placeholder="请输入数字" addonAfter="万元" />)}
                </FormItem>
              </Col>
              <Col span={12}>
                <FormItem
                  {...layoutConfig(10, 12)}
                  label="当前授信"
                  className={styles.addonGroup}
                >
                  {getFieldDecorator(
                    `loanAccreditedRecordDtosList[${i}].currentCreditAmountWan`,
                    {
                      rules: [
                        {
                          pattern: /^(?!0+(\.0+)?$)\d+(\.\d+)?$/,
                          message: '请输入数字'
                        }
                      ]
                    }
                  )(<Input placeholder="请输入数字" addonAfter="万元" />)}
                </FormItem>
              </Col>
              <Col span={24} className={styles.radioGroup}>
                <label>允许部分还款：</label>
                <label>{f.allowPartRepay ? '是' : '否'}</label>
              </Col>
              {/*{id ? (
                <Col span={24} className={styles.radioGroup}>
                  <label>允许部分还款：</label>
                  <label>
                    {f.allowPartRepay ? '是' : '否'}
                  </label>
                  <label />
                </Col>
              ) : (
                <Col span={24} className={styles.radioGroup}>
                  <label>允许部分还款：</label>
                  <label>{f.allowPartRepay ? '是' : '否'}</label>
                </Col>
              )}*/}
            </Row>
          ))}
      </Form>
    </Modal>
  );
});
