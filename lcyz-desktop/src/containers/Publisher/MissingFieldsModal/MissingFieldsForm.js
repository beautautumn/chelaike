import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form, Input, Radio } from 'antd'
import { Datepicker, Select } from 'components'
import Textarea from 'react-textarea-autosize'
import {
  BrandSelectGroup,
  BrandSelect,
  SeriesSelect,
  StyleSelect
} from 'components/CarPublish'

const formItemLayout = {
  labelCol: { span: 5 },
  wrapperCol: { span: 14 },
}

const platformNames = {
  che168: '二手车之家',
  ganji: '赶集网',
  com58: '58同城',
  yiche: '易车网',
  official: '官网',
  weshop: '微店',
}

@reduxForm({
  form: 'missingFields',
})
export default class MissingFieldsForm extends Component {
  static propTypes = {
    missingFields: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  renderInput = (platform, fieldInfo, index) => {
    const field = this.props.fields[platform][fieldInfo.fieldName]
    let input = null
    if (fieldInfo.type === 'text') {
      input = (
        <Input {...field} />
      )
    }
    if (fieldInfo.type === 'textarea') {
      input = (
        <Textarea rows={2} className="ant-input ant-input-lg" {...field} />
      )
    }
    if (fieldInfo.type === 'date') {
      input = (
        <Datepicker format="day" {...field} />
      )
    }
    if (fieldInfo.type === 'select') {
      input = (
        <Select
          items={fieldInfo.values || []}
          size="default"
          {...field}
        />
      )
    }
    if (fieldInfo.type === 'radio') {
      input = (
        <Radio.Group
          {...field}
          onChange={event => field.onChange(event.target.value)}
        >
        {fieldInfo.values.map((enumValue, index) => (
          <Radio key={index} value={enumValue.value}>{enumValue.text}</Radio>
        ))}
        </Radio.Group>
      )
    }

    return (
      <Form.Item {...formItemLayout} label={`${fieldInfo.name}：`} key={index}>
        {input}
      </Form.Item>
    )
  }

  renderBrandGroup = (platform, brand, series, style) => (
    <BrandSelectGroup key={platform} as={platform}>
      <div>
        <Form.Item {...formItemLayout} label="品牌：">
          <BrandSelect {...brand} />
        </Form.Item>
        <Form.Item {...formItemLayout} label="车系：">
          <SeriesSelect {...series} />
        </Form.Item>
        <Form.Item {...formItemLayout} label="车型：">
          <StyleSelect {...style} />
        </Form.Item>
      </div>
    </BrandSelectGroup>
  )

  renderPlatform = (platform, missingFields) => {
    const inputs = []
    let brand
    let series
    let style
    for (let i = 0; i < missingFields.length; ++i) {
      const fieldInfo = missingFields[i]
      if (fieldInfo.type === 'select' && fieldInfo.fieldName === 'brand_name_id') {
        brand = this.props.fields[platform][fieldInfo.fieldName]
        if (brand && series && style) {
          inputs.push(this.renderBrandGroup(platform, brand, series, style))
        }
        continue
      }
      if (fieldInfo.type === 'select' && fieldInfo.fieldName === 'series_name_id') {
        series = this.props.fields[platform][fieldInfo.fieldName]
        if (brand && series && style) {
          inputs.push(this.renderBrandGroup(platform, brand, series, style))
        }
        continue
      }
      if (fieldInfo.type === 'select' && fieldInfo.fieldName === 'style_name_id') {
        style = this.props.fields[platform][fieldInfo.fieldName]
        if (brand && series && style) {
          inputs.push(this.renderBrandGroup(platform, brand, series, style))
        }
        continue
      }
      inputs.push(this.renderInput(platform, fieldInfo, i))
    }
    return (
      <div key={platform}>
        <h5>{platformNames[platform]}</h5>
        {inputs}
      </div>
    )
  }

  render() {
    const { missingFields } = this.props
    return (
      <Form horizontal>
        {Object.keys(missingFields).map(name => (
          this.renderPlatform(name, missingFields[name])
        ))}
      </Form>
    )
  }
}
