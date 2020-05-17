import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Segment, Datepicker, Select, FormItem, SearchBarActions } from 'components'
import { shallowEqual } from 'react-pure-render'
import { Row, Col, Input, Form as AForm } from 'antd'

@reduxForm({
  form: 'serviceAppointmentSearch',
  fields: [
    'customerNameOrCustomerPhoneCont',
    'serviceAppointmentTypeEq', 'createdAtGteq', 'createdAtLteq'
  ]
})
export default class SearchBarForm extends Component {
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
                  placeholder="搜索客户名称／客户电话"
                  {...fields.customerNameOrCustomerPhoneCont}
                />
              </FormItem>
            </Col>
            <Col span="12">
              <SearchBarActions handleClear={resetForm} />
            </Col>
          </Row>
          <Row>
            <Col span="9">
              <FormItem label="服务类型" labelCol={{ span: 4 }} wrapperCol={{ span: 14 }}>
                <Select
                  items={enumValues.service_appointment.service_appointment_type}
                  emptyText="不限"
                  {...fields.serviceAppointmentTypeEq}
                />
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="预约日期" labelCol={{ span: 4 }}>
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
