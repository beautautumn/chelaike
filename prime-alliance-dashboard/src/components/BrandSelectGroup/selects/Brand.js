import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class BrandSelect extends Component {
  static propTypes = {
    value: PropTypes.string,
  }

  static contextTypes = {
    brands: PropTypes.array.isRequired,
    handleBrandChange: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { value } = this.props
    // 如果有初始值
    if (value) {
      this.context.handleBrandChange(value)
    }
  }

  componentWillReceiveProps(nextProps) {
    const currentValue = this.props.value
    const nextValue = nextProps.value
    // 如果值有变化
    if (currentValue !== nextValue && nextValue) {
      this.context.handleBrandChange(nextValue)
    }
  }

  render() {
    const items = this.context.brands.map((brand) => ({
      value: brand.name,
      text: `${brand.firstLetter} ${brand.name}`,
    }))

    return (
      <Select
        items={items}
        prompt="选择品牌"
        {...this.props}
      />
    )
  }
}
