import React, { Component, PropTypes } from 'react'
import { ShopSelect, BrandSelectGroup, BrandSelect, SeriesSelect } from 'components'
import { Col, Input } from 'antd'
import styles from '../CarSearchBar.scss'

export default class Brand extends Component {
  static propTypes = {
    query: PropTypes.object,
    handleChange: PropTypes.func.isRequired,
  }

  render() {
    const {
      query,
      handleChange,
      type
    } = this.props

    const as = type === 'StockOutCarList' ? 'outOfStock' : 'inStock'

    return (
      <BrandSelectGroup as={as}>
        <tr>
          <td className={styles.label}>
            基本信息
          </td>
          <td className={styles.input}>
            <Input.Group>
              <Col span="6">
                <ShopSelect
                  size="default"
                  prompt="分店"
                  value={query.shopIdEq}
                  onChange={handleChange('shopIdEq')}
                  emptyText="不限分店"
                />
              </Col>
              <Col span="6">
                <BrandSelect
                  size="default"
                  prompt="品牌"
                  value={query.brandNameEq}
                  onChange={handleChange('brandNameEq')}
                  emptyText="不限品牌"
                />
              </Col>
              <Col span="6">
                <SeriesSelect
                  size="default"
                  prompt="车系"
                  value={query.seriesNameEq}
                  onChange={handleChange('seriesNameEq')}
                  emptyText="不限车系"
                />
              </Col>
            </Input.Group>
          </td>
        </tr>
      </BrandSelectGroup>
    )
  }
}
