import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class ProvinceSelect extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string
  }

  static contextTypes = {
    provinces: PropTypes.array.isRequired,
    handleProvinceChange: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { defaultValue } = this.props
    // 如果有初始值
    if (defaultValue) {
      this.context.handleProvinceChange(defaultValue)
    }
  }

  componentWillReceiveProps(nextProps) {
    const currentValue = this.props.value || this.props.defaultValue
    const nextValue = nextProps.value || nextProps.defaultValue
    // 如果值有变化
    if (currentValue !== nextValue && nextValue) {
      this.context.handleProvinceChange(nextProps.value)
    }
  }

  render() {
    const items = this.context.provinces.map((province) => (
      { value: province.name, text: province.name }
    ))

    return (
      <Select
        items={items}
        prompt="选择省份"
        {...this.props}
      />
    )
  }
}
