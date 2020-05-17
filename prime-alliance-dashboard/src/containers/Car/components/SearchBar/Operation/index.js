import React, { PropTypes } from 'react'
import { Datepicker } from 'components'
import { Input, Col } from 'antd'
import styles from '../style.scss'

export default function Operation({ query, handleChange }) {
  return (
    <tr>
      <td className={styles.label}>
        操作日期
      </td>
      <td className={styles.input}>
        <Input.Group>
          <Col className={styles.hasSplit} span="4">
            <Datepicker
              size="default"
              placeholder="开始日期"
              value={query.operationRecordsCreatedAtGteq}
              onChange={handleChange('operationRecordsCreatedAtGteq')}
            />
          </Col>
          <Col span="1">
            <p className="ant-form-split">-</p>
          </Col>
          <Col className={styles.hasSplit} span="4">
            <Datepicker
              size="default"
              placeholder="结束日期"
              value={query.operationRecordsCreatedAtLteq}
              onChange={handleChange('operationRecordsCreatedAtLteq')}
            />
          </Col>
        </Input.Group>
      </td>
    </tr>
  )
}

Operation.propTypes = {
  query: PropTypes.object,
  handleChange: PropTypes.func.isRequired,
}
