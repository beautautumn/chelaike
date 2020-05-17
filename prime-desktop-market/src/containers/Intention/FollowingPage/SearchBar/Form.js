import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { shallowEqual } from 'react-pure-render'
import {
  Segment,
  Select,
  UserSelect,
  ChannelSelect,
  Datepicker,
  IntentionLevelSelect,
  FormItem,
  SearchBarActions,
} from 'components'
import { Row, Col, Input, Form as AForm } from 'antd'

@reduxForm({
  form: 'followingIntentionSearch',
  fields: [
    'customerNameOrCustomerPhoneOrIntentionNoteCont',
    'intentionLevelIdEq',
    'channelIdEq',
    'stateEq',
    'assigneeIdEq',
    'createdAtLteq',
    'createdAtGteq',
    'sourceCarIdNotNull'
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
    const { enumValues, fields, resetForm } = this.props

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
            <Col span="7">
              <FormItem label="客户级别" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <IntentionLevelSelect emptyText="不限" {...fields.intentionLevelIdEq} />
              </FormItem>
            </Col>
            <Col span="7">
              <FormItem label="客户来源" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <ChannelSelect emptyText="不限" {...fields.channelIdEq} />
              </FormItem>
            </Col>
            <Col span="7">
              <FormItem label="意向状态" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <Select
                  items={enumValues.intention.state}
                  emptyText="不限"
                  {...fields.stateEq}
                />
              </FormItem>
            </Col>
          </Row>
          <Row>
            <Col span="7">
              <FormItem label="归属员工" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <UserSelect emptyText="不限" {...fields.assigneeIdEq} as="all" />
              </FormItem>
            </Col>
            <Col span="7">
              <FormItem label="意向车辆" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <Select
                  items={[{ id: '1', text: '只显示具有意向车辆' }]}
                  emptyText="不限"
                  {...fields.sourceCarIdNotNull}
                />
              </FormItem>
            </Col>
            <Col span="7">
              <FormItem label="创建日期" labelCol={{ span: 6 }}>
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
