import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Select, Datepicker, UserSelect } from 'components'
import { Input, Col } from 'antd'
import styles from '../CarSearchBar.scss'

export default class StockOut extends PureComponent {
  static propTypes = {
    query: PropTypes.object,
    enumValues: PropTypes.object,
    handleChange: PropTypes.func.isRequired
  }

  render() {
    const {
      query,
      enumValues,
      handleChange
    } = this.props

    return (
      <tr>
        <td className={styles.label}>
          出库信息
        </td>
        <td className={styles.input}>
          <Input.Group>
            <Col span="6">
              <UserSelect
                size="default"
                prompt="选择销售员"
                value={query.stockOutInventorySellerIdEq}
                onChange={handleChange('stockOutInventorySellerIdEq')}
                emptyText="不限销售员"
                as="all"
              />
            </Col>
            <Col span="6">
              <Select
                size="default"
                prompt="选择销售类型"
                items={enumValues.stock_out_inventory.sales_type}
                value={query.stockOutInventorySalesTypeEq}
                onChange={handleChange('stockOutInventorySalesTypeEq')}
                emptyText="不限销售类型"
              />
            </Col>
            <Col className={styles.hasSplit} span="4">
              <Datepicker
                size="default"
                placeholder="选择出库日期"
                value={query.stockOutAtGteq}
                onChange={handleChange('stockOutAtGteq')}
              />
            </Col>
            <Col span="1">
              <p className="ant-form-split">到</p>
            </Col>
            <Col span="4">
              <Datepicker
                size="default"
                placeholder="选择出库日期"
                value={query.stockOutAtLteq}
                onChange={handleChange('stockOutAtLteq')}
              />
            </Col>
          </Input.Group>
        </td>
      </tr>
    )
  }
}
