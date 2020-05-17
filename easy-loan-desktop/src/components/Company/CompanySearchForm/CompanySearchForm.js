import React from 'react';
import { Form, Row, Col, Input, Icon, Button, Select } from 'antd';
import layoutConfig from '../../../utils/formItemLayoutFacory';
import styles from './CompanySearchForm.scss';

const FormItem = Form.Item;
const Option = Select.Option;

class SearchForm extends React.Component {
  handleShowModal = () => () => {
    this.props.showModal();
  };

  render() {
    const { form, assignees, inventors, currentUser } = this.props;
    const { getFieldDecorator } = form;
    return (
      <Form className={styles.form}>
        <Row>
          <Col span={12}>
            <FormItem className={styles.keyWord}>
              {getFieldDecorator('shopName', {})(
                <Input
                  placeholder="搜索 商家"
                  prefix={<Icon type="search" />}
                />
              )}
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span={19}>
            <FormItem {...layoutConfig(2, 22)} label="归属业务员">
              <Col span={5}>
                {getFieldDecorator('assigneeId', {})(
                  <Select placeholder="业务员">
                    <Option value="">不限</Option>
                    {assignees &&
                      assignees.map(assignee => (
                        <Option key={assignee.id}>{assignee.name}</Option>
                      ))}
                  </Select>
                )}
              </Col>
            </FormItem>
            <FormItem {...layoutConfig(2, 22)} label="盘库员">
              <Col span={5}>
                {getFieldDecorator('inventoryUserId', {})(
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
          <Col span={5} className={styles.addButton}>
            {currentUser.authorities.includes('车商授信管理') && (
              <Button onClick={this.handleShowModal()}>新增授信车商</Button>
            )}
          </Col>
        </Row>
      </Form>
    );
  }
}

export default Form.create({
  onValuesChange(props, values) {
    props.onQuery(values);
  }
})(SearchForm);
