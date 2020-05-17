import React, { Component, PropTypes } from 'react'
import { Select as AntdSelect } from 'antd'

const Option = AntdSelect.Option

export default class Select extends Component {
  static propTypes = {
    defaultValue: PropTypes.oneOfType([PropTypes.string, PropTypes.number, PropTypes.array]),
    value: PropTypes.oneOfType([PropTypes.string, PropTypes.number, PropTypes.array]),
    prompt: PropTypes.string,
    disabled: PropTypes.bool,
    emptyText: PropTypes.string,
    behavior: PropTypes.string,
    items: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.object
    ]),
    onChange: PropTypes.func,
    size: PropTypes.string,
    style: PropTypes.object,
    multiple: PropTypes.bool,
  }

  static defaultProps = {
    size: 'large',
    prompt: '请选择',
    items: [],
    style: { width: '100%' },
  }

  handleFilter = (input, child) => (
    child.props.children.toUpperCase().includes(input.toUpperCase())
  )

  normalizeItems(items) {
    if (!Array.isArray(items)) {
      return Object.keys(items).map((key) => ({
        value: key,
        text: items[key],
      }))
    }
    return items.map((item) => ({
      value: item.value || item.id,
      text: item.text || item.name
    }))
  }

  render() {
    const { defaultValue, value, prompt, emptyText,
      onChange, size, style, multiple, disabled } = this.props

    let items = this.normalizeItems(this.props.items)

    if (emptyText) {
      items = [{ value: '', text: emptyText }, ...items]
    }

    return (
      <AntdSelect
        showSearch
        multiple={multiple}
        onChange={onChange}
        defaultValue={defaultValue}
        value={value}
        disabled={disabled}
        filterOption={this.handleFilter}
        optionFilterProp="children"
        notFoundContent="无法找到"
        searchPlaceholder="输入关键词"
        size={size}
        placeholder={prompt}
        style={style}
      >
        {items.map((item, index) => (
          <Option key={index} value={item.value}>{item.text}</Option>
        ))}
      </AntdSelect>
    )
  }
}
