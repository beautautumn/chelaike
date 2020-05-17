import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class AllyShopSelect extends Component {
  static propTypes = {
    value: PropTypes.string,
    onChange: PropTypes.func
  }

  static contextTypes = {
    shops: PropTypes.array,
    resetShops: PropTypes.bool
  }

  componentDidUpdate() {
    if (this.context.resetShops) {
      this.props.onChange('')
    }
  }

  render() {
    const shops = this.context.shops || []

    const items = shops.map(shop => (
      {
        value: shop.id.toString(),
        text: shop.name
      }
    ))

    return (
      <Select
        items={items}
        prompt="选择对方分店"
        {...this.props}
      />
    )
  }
}
