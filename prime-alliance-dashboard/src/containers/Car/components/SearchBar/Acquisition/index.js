import React, { PropTypes } from 'react'
import { Select, Datepicker } from 'components'
import map from 'lodash/map'
import { Input, Col } from 'antd'
import styles from '../style.scss'

export default function Acquisition({ query, enumValues, handleChange }) {
  return (
    <tr>
      <td className={styles.label}>
        收购信息
      </td>
      <td className={styles.input}>
        <Input.Group>
          <Col span="6">
            <Select
              size="default"
              prompt="收购类型"
              items={map(enumValues.car.acquisition_type, (text, value) => ({ value, text }))}
              value={query.acquisitionTypeEq}
              onChange={handleChange('acquisitionTypeEq')}
              emptyText="不限收购类型"
            />
          </Col>

          <Col className={styles.hasSplit} span="6">
            <Datepicker
              size="default"
              placeholder="入库日期"
              value={query.stockInOn}
              onChange={handleChange('stockInOn')}
            />
          </Col>
        </Input.Group>
      </td>
    </tr>
  )
}

Acquisition.propTypes = {
  query: PropTypes.object,
  enumValues: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
}
