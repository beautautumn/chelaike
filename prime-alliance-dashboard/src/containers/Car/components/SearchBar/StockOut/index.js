import React, { PropTypes } from 'react'
import { Select, Datepicker } from 'components'
import { Input, Col } from 'antd'
import styles from '../style.scss'

export default function StockOut({ query, enumValues, handleChange }) {
  return (
    <tr>
      <td className={styles.label}>
        出库信息
      </td>
      <td className={styles.input}>
        <Input.Group>
          <Col span="6">
            <Select
              size="default"
              prompt="销售类型"
              items={enumValues.stock_out_inventory.sales_type}
              value={query.stockOutInventorySalesTypeEq}
              onChange={handleChange('stockOutInventorySalesTypeEq')}
              emptyText="不限销售类型"
            />
          </Col>
          <Col className={styles.hasSplit} span="6">
            <Datepicker
              size="default"
              placeholder="出库日期"
              value={query.stockOutOn}
              onChange={handleChange('stockOutOn')}
            />
          </Col>
        </Input.Group>
      </td>
    </tr>
  )
}

StockOut.propTypes = {
  query: PropTypes.object,
  enumValues: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
}
