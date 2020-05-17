import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class BrandSelect extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string
  }

  static contextTypes = {
    brands: PropTypes.array,
    handleBrandChange: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { defaultValue } = this.props
    // 如果有初始值
    if (defaultValue) {
      this.context.handleBrandChange(defaultValue)
    }
  }

  componentWillReceiveProps(nextProps) {
    const currentValue = this.props.value || this.props.defaultValue
    const nextValue = nextProps.value || nextProps.defaultValue
    // 如果值有变化
    if (currentValue !== nextValue && nextValue) {
      this.context.handleBrandChange(nextValue)
    }
  }

  render() {
    let items = []
    if (this.context.brands) {
      items = this.context.brands.map((brand) => ({
        value: brand.value,
        text: brand.name
      }))
    }

    return (
      <Select
        items={items}
        prompt="选择品牌"
        {...this.props}
      />
    )
  }
}
