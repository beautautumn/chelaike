import React, { Component, PropTypes } from 'react'
import { Input, Radio } from 'antd'
const RadioGroup = Radio.Group

export default class FeatureInput extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    path: PropTypes.string.isRequired
  }

  shouldComponentUpdate(nextProps) {
    return (this.props.field.present !== nextProps.field.present) ||
      (this.props.field.value !== nextProps.field.value)
  }

  render() {
    const { field, onChange, path } = this.props

    const disabled = !field.present

    if (field.type === 'text') {
      return (
        <Input
          disabled={disabled}
          placeholder="请输入"
          value={field.value}
          onChange={event => onChange(path, 'value', event.currentTarget.value)}
        />
      )
    }
    if (field.type === 'select') {
      return (
        <RadioGroup
          disabled={disabled}
          onChange={event => onChange(path, 'value', event.target.value)}
          value={field.value}
          size="small"
        >
          <Radio key="a" value="标配">标配</Radio>
          <Radio key="b" value="选配">选配</Radio>
          <Radio key="c" value="加装">加装</Radio>
        </RadioGroup>
      )
    }
    return null
  }
}
