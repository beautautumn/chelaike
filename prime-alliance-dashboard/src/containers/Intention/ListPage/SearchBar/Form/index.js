import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Row, Col, Button } from 'antd'
import { Select, Datepicker, FormActions, FormItem } from 'components'

function Form({ fields, handleSubmit, handleReset, enumValues }) {
  const formItemLayout = {
    labelCol: { span: 4 },
    wrapperCol: { span: 18 },
  }

  return (
    <AForm horizontal>
      <Row>
        <Col span="16">
          <FormItem {...formItemLayout}>
            <Input
              type="text"
              placeholder="搜索客户名称／客户电话／意向描述"
              {...fields.customerNameOrCustomerPhoneOrIntentionNoteCont}
            />
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="8">
          <FormItem {...formItemLayout} label="归属车商：">
            <Select.Company emptyText="不限" {...fields.companyIdEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="归属员工：">
            <Select.User emptyText="不限" {...fields.assigneeIdEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="录入人：">
            <Select.User emptyText="不限" {...fields.creatorIdEq} />
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="8">
          <FormItem {...formItemLayout} label="客户级别：">
            <Select.IntentionLevel emptyText="不限" {...fields.intentionLevelIdEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="客户来源：">
            <Select.Channel emptyText="不限" {...fields.channelIdEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="意向状态：">
            <Select items={enumValues.intention.state} emptyText="不限" {...fields.allianceStateEq} />
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="8">
          <FormItem {...formItemLayout} label="创建日期：">
            <Datepicker {...fields.createdOn} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="预约日期：">
            <Datepicker {...fields.interviewedOn} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="分配日期：">
            <Datepicker {...fields.allianceAssignedOn} />
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="8">
          <FormItem {...formItemLayout} label="到店日期：">
            <Datepicker {...fields.inShopOn} />
          </FormItem>
        </Col>
      </Row>
      <Row>
        <Col span="8" offset="16" style={{ textAlign: 'right' }}>
          <FormActions>
            <Button type="primary" htmlType="submit" onClick={handleSubmit}>搜索</Button>
            <Button onClick={handleReset}>清除条件</Button>
          </FormActions>
        </Col>
      </Row>
    </AForm>
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  handleReset: PropTypes.func.isRequired,
  enumValues: PropTypes.object.isRequired,
}

export default reduxForm({
  form: 'intentionSearch',
  fields: [
    'customerNameOrCustomerPhoneOrIntentionNoteCont',
    'companyIdEq',
    'assigneeIdEq',
    'creatorIdEq',
    'intentionLevelIdEq',
    'channelIdEq',
    'allianceStateEq',
    'createdOn',
    'interviewedOn',
    'allianceAssignedOn',
    'inShopOn',
  ],
})(Form)
