import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class CarShopSelect extends Component {

  static contextTypes = {
    shops: PropTypes.array.isRequired,
    handleShopChange: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { value } = this.props
    // 如果有初始值
    if (value) {
      this.context.handleShopChange(value)
    }
  }

  componentWillReceiveProps(nextProps) {
    const currentValue = this.props.value || this.props.defaultValue
    const nextValue = nextProps.value || nextProps.defaultValue
    // 如果值有变化
    if (currentValue !== nextValue && nextValue) {
      this.context.handleShopChange(nextProps.value)
    }
  }

  render() {
    const items = this.context.shops.map((shop) => (
      { value: shop.id, text: shop.name }
    ))
    return (
      <Select
        items={items}
        prompt="选择分店"
        {...this.props}
      />
    )
  }
}
