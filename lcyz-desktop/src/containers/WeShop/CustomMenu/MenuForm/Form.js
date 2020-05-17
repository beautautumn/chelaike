import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import validation from './validation'
import { Form as AntdForm, Input, Radio } from 'antd'
import { FormItem } from 'components'

@reduxForm({
  form: 'customMenu',
  fields: [
    'name', 'cate', 'message', 'url'
  ],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleInputBlur: PropTypes.func.isRequired,
    handleRadioChange: PropTypes.func.isRequired,
  }

  handleBlur = field => (event) => {
    field.onBlur(event)
    const { value } = event.target
    if (value) {
      this.props.handleInputBlur(event)
    }
  }

  render() {
    const { fields, handleRadioChange } = this.props

    const formItemLayout = {
      labelCol: { span: 5 },
      wrapperCol: { span: 15 },
    }

    return (
      <AntdForm horizontal>
        <FormItem
          {...formItemLayout}
          label="菜单名称："
          help="字数不超过8个汉字或16个字母"
          field={fields.name}
        >
          <Input {...fields.name} onBlur={this.handleBlur(fields.name)} />
        </FormItem>
        {fields.cate.value !== 'group' &&
          <FormItem
            {...formItemLayout}
            label="菜单内容："
          >
            <Radio.Group {...fields.cate} onChange={handleRadioChange} >
              <Radio value="msg">发送消息</Radio>
              <Radio value="url">跳转网页</Radio>
            </Radio.Group>
          </FormItem>
        }
        {fields.cate.value === 'msg' &&
          <FormItem {...formItemLayout} label=" " field={fields.message}>
            <Textarea
              {...fields.message}
              className="ant-input ant-input-lg"
              rows={8}
              onBlur={this.handleBlur(fields.message)}
            />
          </FormItem>
        }
        {fields.cate.value === 'url' &&
          <FormItem
            {...formItemLayout}
            label="页面地址："
            field={fields.url}
            help="订阅者点击该子菜单会跳到以上链接"
          >
            <Input {...fields.url} onBlur={this.handleBlur(fields.url)} />
          </FormItem>
        }
      </AntdForm>
    )
  }
}
