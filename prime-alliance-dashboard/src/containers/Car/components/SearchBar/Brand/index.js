import React, { PropTypes } from 'react'
import { Select, BrandSelectGroup } from 'components'
import { Col, Input } from 'antd'
import styles from '../style.scss'

export default function Brand({ query, handleChange, type }) {
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
              <Select.Company
                size="default"
                value={query.companyIdEq}
                onChange={handleChange('companyIdEq')}
                emptyText="不限车商"
              />
            </Col>
            <Col span="6">
              <BrandSelectGroup.Brand
                size="default"
                prompt="品牌"
                value={query.brandNameEq}
                onChange={handleChange('brandNameEq')}
                emptyText="不限品牌"
              />
            </Col>
            <Col span="6">
              <BrandSelectGroup.Series
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

Brand.propTypes = {
  query: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
  type: PropTypes.string.isRequired,
}
