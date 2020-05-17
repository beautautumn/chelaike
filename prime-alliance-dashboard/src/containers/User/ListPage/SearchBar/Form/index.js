import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Row, Col, Button } from 'antd'
import { Select, FormActions, FormItem } from 'components'

function Form({ fields, enumValues, handleSubmit, handleReset }) {
  const formItemLayout = {
    labelCol: { span: 4 },
    wrapperCol: { span: 18 },
  }

  return (
    <AForm horizontal>
      <Row>
        <Col span="8">
          <FormItem {...formItemLayout} label="姓名：">
            <Input type="text" {...fields.nameCont} />
          </FormItem>
          <FormItem {...formItemLayout} label="所属经理：">
            <Select.User emptyText="不限" {...fields.managerIdEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="所属角色：">
            <Select.Role emptyText="不限" {...fields.authorityRolesIdEq} />
          </FormItem>
          <FormItem {...formItemLayout} label="联系电话：">
            <Input type="text" {...fields.phoneEq} />
          </FormItem>
        </Col>
        <Col span="8">
          <FormItem {...formItemLayout} label="启用状态：">
            <Select
              items={enumValues.user.state}
              prompt="选择状态"
              emptyText="不限"
              {...fields.stateEq}
            />
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
  enumValues: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  handleReset: PropTypes.func.isRequired,
}

export default reduxForm({
  form: 'userSearch',
  fields: [
    'managerIdEq', 'authorityRolesIdEq', 'nameCont', 'phoneEq', 'stateEq',
  ],
})(Form)
