import React from 'react';
import 'moment/locale/zh-cn';
import { Form, Row, Col, Input, Icon, Select, DatePicker } from 'antd';
import layoutConfig from '../../../utils/formItemLayoutFacory';
import styles from './InventorySearchForm.scss';
const FormItem = Form.Item;
const Option = Select.Option;

class InventorySearchForm extends React.Component {
  render() {
    const { form, inventors } = this.props;
    const { getFieldDecorator } = form;

    return (
      <Form className={styles.form}>
        <Row>
          <Col span={12}>
            <FormItem className={styles.keyWord}>
              {getFieldDecorator('searchValue', {})(
                <Input
                  placeholder="搜索 商家"
                  prefix={<Icon type="search" />}
                />
              )}
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span={18}>
            <FormItem {...layoutConfig(2, 22)} label="盘库日期">
              <Col span={5}>
                <FormItem>
                  {getFieldDecorator('fromTime', {})(
                    <DatePicker placeholder="开始日期" />
                  )}{' '}
                  ~
                </FormItem>
              </Col>
              <Col span={5}>
                <FormItem>
                  {getFieldDecorator('toTime', {})(
                    <DatePicker placeholder="结束日期" />
                  )}
                </FormItem>
              </Col>
            </FormItem>
            {/*<FormItem {...layoutConfig(2, 22)} label="盘库日期">
              {getFieldDecorator('fromTime', {})(
                <DatePicker placeholder="开始日期" />
              )}
              ~
              {getFieldDecorator('toTime', {})(
                <DatePicker placeholder="结束日期" />
              )}
            </FormItem>*/}
            <FormItem {...layoutConfig(2, 22)} label="盘库员">
              <Col span={5}>
                {getFieldDecorator('inventorId', {})(
                  <Select placeholder="盘库员">
                    <Option value="">不限</Option>
                    {inventors &&
                      inventors.map(checker => (
                        <Option key={checker.id}>{checker.name}</Option>
                      ))}
                  </Select>
                )}
              </Col>
            </FormItem>
          </Col>
        </Row>
      </Form>
    );
  }
}

export default Form.create({
  onValuesChange(props, values) {
    const fromTime = values['fromTime'];
    const toTime = values['toTime'];
    if (fromTime && toTime) {
      let value = {
        ...values,
        fromTime: fromTime.format('YYYY-MM-DD'),
        toTime: toTime.format('YYYY-MM-DD')
      };
      props.onQuery(value);
    }
    if (fromTime) {
      let value = {
        ...values,
        fromTime: fromTime.format('YYYY-MM-DD')
      };
      props.onQuery(value);
    }
    if (toTime) {
      let value = {
        ...values,
        toTime: toTime.format('YYYY-MM-DD')
      };
      props.onQuery(value);
    } else {
      console.log('表单的值==========', values);
      props.onQuery(values);
    }
  }
})(InventorySearchForm);
