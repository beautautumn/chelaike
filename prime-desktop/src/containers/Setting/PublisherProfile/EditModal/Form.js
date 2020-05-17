import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { FormItem } from 'components'
import validation from './validation'
import { Input, Form as AntdForm } from 'antd'
import Textarea from 'react-textarea-autosize'
import styles from './Form.scss'

@reduxForm({
  form: 'platformProfile',
  fields: ['platform', 'data.username', 'data.password', 'data.defaultDescription'],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    siteName: PropTypes.string.isRequired,
  }

  render() {
    const { fields, error } = this.props

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 18 },
    }

    return (
      <AntdForm horizontal>
        {/* http://stackoverflow.com/a/22694173 */}
        <input style={{ display: 'none' }} />
        <input type="password" style={{ display: 'none' }} />
        {/* end */}
        <FormItem {...formItemLayout} label="平台名称：" >
          <b className="ant-form-text">{this.props.siteName}</b>
        </FormItem>
        <FormItem {...formItemLayout} label="账号：" required field={fields.data.username}>
          <Input {...fields.data.username} />
        </FormItem>
        <FormItem {...formItemLayout} label="密码：" required field={fields.data.password}>
          <Input type="password" {...fields.data.password} />
        </FormItem>
        <FormItem
          {...formItemLayout}
          label="默认说明："
          required
          field={fields.data.defaultDescription}
        >
          <Textarea
            rows={2}
            className="ant-input ant-input-lg"
            {...fields.data.defaultDescription}
          />
        </FormItem>
        {error && <div className={styles.error}>{error}</div>}
      </AntdForm>
    )
  }
}
