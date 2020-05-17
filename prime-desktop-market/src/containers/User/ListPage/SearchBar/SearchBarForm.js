import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form, Input, Row, Col, Button } from 'antd'
import { Select, UserSelect, ShopSelect, RoleSelect } from 'components'
import styles from './SearchBar.scss'

@reduxForm({
  form: 'userSearch',
  fields: [
    'shopIdEq', 'managerIdEq', 'authorityRolesIdEq', 'nameCont', 'phoneEq', 'stateEq'
  ]
})
export default class SearchBarForm extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    resetForm: PropTypes.func.isRequired,
    onReset: PropTypes.func.isRequired
  }

  handleReset = () => {
    this.props.resetForm()
    this.props.onReset()
  }

  render() {
    const { fields, enumValues, handleSubmit } = this.props

    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 }
    }

    return (
      <Form horizontal className={styles.form}>
        <Row>
          <Col span="8">
            <Form.Item {...formItemLayout} label="所属分店：">
              <ShopSelect emptyText="不限" {...fields.shopIdEq} />
            </Form.Item>
            <Form.Item {...formItemLayout} label="姓名：">
              <Input type="text" {...fields.nameCont} />
            </Form.Item>
          </Col>
          <Col span="8">
            <Form.Item {...formItemLayout} label="所属经理：">
              <UserSelect emptyText="不限" {...fields.managerIdEq} as="manager" />
            </Form.Item>
            <Form.Item {...formItemLayout} label="联系电话：">
              <Input type="text" {...fields.phoneEq} />
            </Form.Item>
          </Col>
          <Col span="8">
            <Form.Item {...formItemLayout} label="所属角色：">
              <RoleSelect emptyText="不限" {...fields.authorityRolesIdEq} />
            </Form.Item>
            <Form.Item {...formItemLayout} label="启用状态：">
              <Select
                items={enumValues.user.state}
                prompt="选择状态"
                emptyText="不限"
                {...fields.stateEq}
              />
            </Form.Item>
          </Col>
        </Row>
        <Row>
          <Col span="8" offset="16" style={{ textAlign: 'right' }}>
            <Button type="primary" htmlType="submit" onClick={handleSubmit}>搜索</Button>
            <Button onClick={this.handleReset}>清除条件</Button>
          </Col>
        </Row>
      </Form>
    )
  }
}
