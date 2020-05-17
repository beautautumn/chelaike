import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Datepicker, UserSelect, CooperationCompanySelect } from 'components'
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
      handleChange
    } = this.props

    return (
      <tr>
        <td className={styles.label}>
          入库信息
        </td>
        <td className={styles.input}>
          <Input.Group>
            <Col span="6">
              <CooperationCompanySelect
                prompt="归属车商"
                value={query.ownerCompanyIdEq}
                onChange={handleChange('ownerCompanyIdEq')}
                emptyText="不限归属车商"
              />
            </Col>

            <Col span="6">
              <UserSelect
                size="default"
                prompt="车源负责人"
                value={query.acquirerIdEq}
                onChange={handleChange('acquirerIdEq')}
                emptyText="不限收购员"
                as="all"
              />
            </Col>

            <Col className={styles.hasSplit} span="4">
              <Datepicker
                size="default"
                placeholder="入库日期"
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
                placeholder="入库日期"
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
