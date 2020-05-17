import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Datepicker, UserSelect, Select } from 'components'
import map from 'lodash/map'
import { Input, Col } from 'antd'
import styles from '../CarSearchBar.scss'

export default class Acquisition extends PureComponent {
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
          收购信息
        </td>
        <td className={styles.input}>
          <Input.Group>
            <Col span="6">
              <UserSelect
                size="default"
                prompt="收购员"
                value={query.acquirerIdEq}
                onChange={handleChange('acquirerIdEq')}
                emptyText="不限收购员"
                as="all"
              />
            </Col>

            <Col span="6">
              <Select
                multiple
                size="default"
                prompt="收购类型"
                items={map(enumValues.car.acquisition_type, (text, value) => ({ value, text }))}
                value={query.acquisitionTypeIn}
                onChange={handleChange('acquisitionTypeIn')}
              />
            </Col>

            <Col className={styles.hasSplit} span="4">
              <Datepicker
                size="default"
                placeholder="收购日期"
                value={query.acquiredAtGteq}
                onChange={handleChange('acquiredAtGteq')}
              />
            </Col>
            <Col span="1">
              <p className="ant-form-split">到</p>
            </Col>
            <Col span="4">
              <Datepicker
                size="default"
                placeholder="收购日期"
                value={query.acquiredAtLteq}
                onChange={handleChange('acquiredAtLteq')}
              />
            </Col>
          </Input.Group>
        </td>
      </tr>
    )
  }
}
