import React from 'react'
import PropTypes from 'prop-types'
import { Form, Icon, Input, Button, Checkbox, Row, Col } from 'antd'
import { CountdownButton } from 'components'
import styles from './LoginForm.scss'

const FormItem = Form.Item

class LoginForm extends React.Component {
  handleSubmit = (e) => {
    e.preventDefault()
    this.props.form.validateFields((err, values) => {
      if (!err) {
        this.props.login(values)
      }
    })
  }

  handleRequestCode = (e) => {
    this.props.form.validateFields()
    const err = this.props.form.getFieldError('phone')
    if (!err) {
      const phone = this.props.form.getFieldValue('phone')
      this.props.codeRequest(phone)
    }
  }

  render() {
    const { loading } = this.props
    const { getFieldDecorator } = this.props.form
    return (
      <Form onSubmit={this.handleSubmit} className={styles.loginForm}>
        <Row type="flex" justify="center" className={styles.brandName}>车融易</Row>
        <FormItem>
          <Row gutter={8}>
            <Col span={15}>
              {getFieldDecorator('phone', {
                rules: [{ required: true, message: '请输入电话号码' }],
              })(
                <Input prefix={<Icon type="phone" style={{ fontSize: 13 }} />} placeholder="电话" />
              )}
            </Col>
            <Col span={9}>
              <CountdownButton
                className={styles.loginFormButton}
                stopCountdown={this.props.stopCountdown}
                onClick={this.handleRequestCode}>
                获取登录码
              </CountdownButton>
            </Col>
          </Row>
        </FormItem>
        <FormItem>
          {getFieldDecorator('verifyCode', {
            rules: [{ required: true, message: '请输入验证码' }],
          })(
            <Input prefix={<Icon type="lock" style={{ fontSize: 13 }} />} placeholder="验证码" />
          )}
        </FormItem>
        <FormItem>
          {getFieldDecorator('rememberMe', {
            valuePropName: 'checked',
            initialValue: true,
          })(
            <Checkbox>记住我</Checkbox>
          )}
          <Button
            type="primary"
            htmlType="submit"
            className={styles.loginFormButton}
            loading={loading}
          >
            登 录
          </Button>
        </FormItem>
      </Form>
    )
  }
}

LoginForm.propTypes = {
  loading: PropTypes.bool.isRequired,
  stopCountdown: PropTypes.bool.isRequired,
  login: PropTypes.func.isRequired,
  codeRequest: PropTypes.func.isRequired,
}

export default Form.create()(LoginForm)
