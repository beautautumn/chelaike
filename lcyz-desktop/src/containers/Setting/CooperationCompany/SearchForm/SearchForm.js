import React, { Component, PropTypes } from 'react'
import { Row, Col, Input, Form, Button } from 'antd'
import { ShopSelect, Segment } from 'components'
import { reduxForm } from 'redux-form'

@reduxForm({
  form: 'cooperationCompanySearchForm',
  fields: [
    'shopIdEq',
    'nameCont'
  ]
})
export default class SearchForm extends Component {

  static propTypes = {
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
    const { fields, handleSubmit } = this.props

    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 }
    }

    return (
      <Segment>
        <Form horizontal>
          <Row>
            <Col span="8">
              <Form.Item {...formItemLayout} label="所属分店：">
                <ShopSelect emptyText="不限" {...fields.shopIdEq} />
              </Form.Item>
            </Col>
            <Col span="8">
              <Form.Item {...formItemLayout} label="商家名称：">
                <Input type="text" {...fields.nameCont} />
              </Form.Item>
            </Col>
            <Col span="8" style={{ textAlign: 'right' }}>
              <Button
                type="primary"
                htmlType="submit"
                onClick={handleSubmit}
                style={{ marginRight: '10px' }}
              >
                搜索
              </Button>
              <Button onClick={this.handleReset}>清除条件</Button>
            </Col>
          </Row>
        </Form>
      </Segment>
    )
  }
}
