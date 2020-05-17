import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Segment, Select, Datepicker, FormItem, SearchBarActions } from 'components'
import { Row, Col, Input, Form as AForm } from 'antd'
import { shallowEqual } from 'react-pure-render'

@reduxForm({
  form: 'intentionSearch',
  fields: [
    'customerNameOrCustomerPhoneOrIntentionNoteCont',
    'stateEq', 'createdAtGteq', 'createdAtLteq'
  ]
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    values: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    resetForm: PropTypes.func.isRequired,
  }

  componentDidUpdate(prevProps) {
    if (!shallowEqual(this.props.values, prevProps.values)) {
      this.props.handleSubmit()
    }
  }

  render() {
    const { fields, enumValues, resetForm } = this.props

    return (
      <Segment>
        <AForm>
          <Row>
            <Col span="12">
              <FormItem>
                <Input
                  placeholder="搜索客户名称／客户电话／意向描述"
                  {...fields.customerNameOrCustomerPhoneOrIntentionNoteCont}
                />
              </FormItem>
            </Col>
            <Col span="12">
              <SearchBarActions handleClear={resetForm} />
            </Col>
          </Row>
          <Row>
            <Col span="9">
              <FormItem label="意向状态" labelCol={{ span: 4 }} wrapperCol={{ span: 14 }}>
                <Select
                  items={enumValues.intention.state}
                  emptyText="不限"
                  {...fields.stateEq}
                />
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="创建日期" labelCol={{ span: 4 }}>
                <Col span="6">
                  <Datepicker {...fields.createdAtGteq} />
                </Col>
                <Col span="1">
                  <p className="ant-form-split">-</p>
                </Col>
                <Col span="6">
                  <Datepicker {...fields.createdAtLteq} />
                </Col>
              </FormItem>
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
