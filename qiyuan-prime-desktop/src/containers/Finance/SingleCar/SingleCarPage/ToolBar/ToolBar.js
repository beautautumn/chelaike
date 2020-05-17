import React, { Component, PropTypes } from 'react'
import { Segment, SortButton } from 'components'
import styles from './ToolBar.scss'
import { decamelizeKeys } from 'humps'
import config from 'config'
import { Button, Row, Col } from 'antd'
import qs from 'qs'

export default class Toolbar extends Component {
  static propTypes = {
    query: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    fetch: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired
  }

  handleSort = ({ orderField, orderBy }) => () => {
    const { query, fetch } = this.props
    fetch({ ...query, orderField, orderBy }, true)
  }

  handleExport = () => {
    const { query, currentUser } = this.props
    let queryObj = {
      AutobotsToken: currentUser.token,
    }
    if (query) {
      queryObj = {
        ...queryObj,
        ...decamelizeKeys(query),
      }
    }
    const queryString = qs.stringify(queryObj, { arrayFormat: 'brackets' })

    return `${config.serverUrl}${config.basePath}/finance/car_incomes/export?${queryString}`
  }

  renderSortButtons() {
    const fields = [
      { key: 'acquired_at', name: '收购日期' },
      { key: 'stock_out_at', name: '销售日期' },
    ]

    const { query } = this.props

    return fields.map((field) => (
      <SortButton key={field.key} field={field} query={query} onSort={this.handleSort} />
    ))
  }

  render() {
    const { total } = this.props

    return (
      <Segment>
        <Row>
          <Col span="10">
            <Button.Group>
              {this.renderSortButtons()}
            </Button.Group>
            <span className={styles.total}>
              共{total}台车
            </span>
          </Col>
          <Col span="12" offset="2">
            <Row type="flex" justify="end">
              <a className="ant-btn ant-btn-lg" href={this.handleExport()}>导出Excel</a>
            </Row>
          </Col>
        </Row>
      </Segment>
    )
  }
}

