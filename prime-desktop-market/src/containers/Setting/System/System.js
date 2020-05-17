import React, { Component } from 'react'
import StockNumber from './StockNumber/StockNumber'
import PriceTag from './PriceTag/PriceTag'
import WeShop from './WeShop/WeShop'
import Helmet from 'react-helmet'

export default class System extends Component {
  render() {
    return (
      <div>
        <Helmet title="系统设置" />
        <StockNumber />
        <PriceTag />
        <WeShop />
      </div>
    )
  }
}
