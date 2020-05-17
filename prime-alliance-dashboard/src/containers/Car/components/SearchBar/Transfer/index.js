import React, { PropTypes } from 'react'
import { Select } from 'components'
import map from 'lodash/map'
import { Input, Col } from 'antd'
import styles from '../style.scss'

export default function Transfer({ query, enumValues, handleChange }) {
  return (
    <tr>
      <td className={styles.label}>
        过户状态
      </td>
      <td className={styles.input}>
        <Input.Group>
          <Col span="6">
            <Select
              size="default"
              prompt="收购过户状态"
              items={map(enumValues.transfer_record.state, (text, value) => ({ value, text }))}
              value={query.acquisitionTransferStateEq}
              onChange={handleChange('acquisitionTransferStateEq')}
              emptyText="不限收购过户状态"
            />
          </Col>
          <Col span="6">
            <Select
              size="default"
              prompt="销售过户状态"
              items={map(enumValues.transfer_record.state, (text, value) => ({ value, text }))}
              value={query.saleTransferStateEq}
              onChange={handleChange('saleTransferStateEq')}
              emptyText="不限不限销售过户状态"
            />
          </Col>
        </Input.Group>
      </td>
    </tr>
  )
}

Transfer.propTypes = {
  query: PropTypes.object,
  enumValues: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
}
