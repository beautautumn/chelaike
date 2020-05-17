import React from 'react';
import { Form, Row, Col, Input, Icon, Radio, Select } from 'antd';
import layoutConfig from '../../utils/formItemLayoutFacory';
import styles from './LoanListSearchForm.scss';
const FormItem = Form.Item;
const RadioButton = Radio.Button;
const RadioGroup = Radio.Group;
const Option = Select.Option;

class SearchForm extends React.Component {
  handleBrandChange = value => {
    const { form, onBrandChange } = this.props;
    setTimeout(() => {
      form.setFieldsValue({ seriesName: '' });
      onBrandChange(value);
    }, 30);
  };

  render() {
    const { loanStatus, brands, series, form, assignees } = this.props;
    const { getFieldDecorator } = form;
    return (
      <Form className={styles.form}>
        <Row>
          <Col span={12}>
            <FormItem className={styles.keyWord}>
              {getFieldDecorator('searchValue', {})(
                <Input
                  placeholder="搜索 品牌／车系／商家"
                  prefix={<Icon type="search" />}
                />
              )}
            </FormItem>
          </Col>
        </Row>
        <Row>
          <Col span={19}>
            <FormItem {...layoutConfig(2, 22)} label="品牌车系">
              <Col span={5}>
                <FormItem>
                  {getFieldDecorator('brandName', {})(
                    <Select
                      onChange={this.handleBrandChange}
                      placeholder="品牌"
                    >
                      <Option value="">不限</Option>
                      {brands &&
                        brands.map(brand => (
                          <Option key={brand.name} value={brand.name}>
                            {brand.name}
                          </Option>
                        ))}
                    </Select>
                  )}
                </FormItem>
              </Col>
              <Col span={5}>
                <FormItem>
                  {getFieldDecorator('seriesName', {})(
                    <Select style={{ marginLeft: 20 }} placeholder="车系">
                      <Option value="">不限</Option>
                      {series &&
                        series.map(item => (
                          <Option key={item.name} value={item.name}>
                            {item.name}
                          </Option>
                        ))}
                    </Select>
                  )}
                </FormItem>
              </Col>
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
          </Col>
        </Row>
        <Row>
          <Col span={19}>
            <FormItem {...layoutConfig(2, 22)} label="状态">
              {getFieldDecorator('state', {})(
                <RadioGroup size="small">
                  <RadioButton value="">不限</RadioButton>
                  {Object.getOwnPropertyNames(loanStatus).map(key => (
                    <RadioButton key={key} value={key}>
                      {loanStatus[key]}
                    </RadioButton>
                  ))}
                </RadioGroup>
              )}
            </FormItem>
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
