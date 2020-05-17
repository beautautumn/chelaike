import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Row, Col, Button } from 'antd'
import { Segment, AuthorityTree, FormActions, FormItem } from 'components'
import validation from './validation'
import styles from '../style.scss'

function Form({ fields, handleSubmit, handleCancel }) {
  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 },
  }

  return (
    <Segment>
      <AForm horizontal onSubmit={handleSubmit} className={styles.form}>
        <Row>
          <Col span="10">
            <Row>
              <Col>
                <FormItem {...formItemLayout} required label="角色名称：" field={fields.name}>
                  <Input id="name" type="text" {...fields.name} />
                </FormItem>
                <FormItem {...formItemLayout} label="角色备注：">
                  <Input id="note" type="textarea" autosize rows={2} {...fields.note} />
                </FormItem>
              </Col>
            </Row>
            <Row>
              <Col span="10" offset="3">
                <FormActions>
                  <Button type="primary" size="large" htmlType="submit">保存</Button>
                  <Button size="large" onClick={handleCancel}>返回</Button>
                </FormActions>
              </Col>
            </Row>
          </Col>
          <Col span="6" offset="1">
            <AuthorityTree name="authorities" {...fields.authorities} />
          </Col>
        </Row>
      </AForm>
    </Segment>
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  handleCancel: PropTypes.func.isRequired,
}

export default reduxForm({
  form: 'role',
  fields: ['id', 'name', 'authorities', 'note'],
  validate: validation,
})(Form)
