import React, { Component, PropTypes } from 'react'
import { Segment } from 'components'
import styles from './ToolBar.scss'
import { decamelizeKeys } from 'humps'
import config from 'config'
import { Row, Col } from 'antd'
import qs from 'qs'

export default class Toolbar extends Component {
  static propTypes = {
    total: PropTypes.number.isRequired,
    storedCount: PropTypes.number.isRequired,
    currentUser: PropTypes.object.isRequired,
  }

  handleExport = () => {
    const { fetchParams, currentUser } = this.props
    let queryObj = {
      AutobotsToken: currentUser.token,
    }
    if (fetchParams) {
      queryObj = {
        ...queryObj,
        ...decamelizeKeys(fetchParams),
      }
    }
    const queryString = qs.stringify(queryObj, { arrayFormat: 'brackets' })

    return `${config.serverUrl}${config.basePath}/maintenance_records/statistics_report?${queryString}`  // eslint-disable-line
  }

  render() {
    const { total, storedCount } = this.props

    return (
      <Segment>
        <Row>
          <Col span="10">
            <span className={styles.total}>
              共查询：{total}次，已入库：{storedCount}台
            </span>
          </Col>
          <Col span="12" offset="2">
            <Row type="flex" justify="end" className={styles.buttons}>
              <a className="ant-btn ant-btn-lg" href={this.handleExport()}>记录导出</a>
            </Row>
          </Col>
        </Row>
      </Segment>
    )
  }
}
