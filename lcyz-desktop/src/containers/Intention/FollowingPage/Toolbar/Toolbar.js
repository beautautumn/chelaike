import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'
import { fetch, batchDestroy } from 'redux/modules/intentions'
import { Segment, SortButton } from 'components'
import styles from './Toolbar.scss'
import { decamelizeKeys } from 'humps'
import config from 'config'
import { Popconfirm, Button, Row, Col } from 'antd'
import can from 'helpers/can'
import qs from 'qs'

@connect(
  state => ({
    fetchParams: state.intentions.following.fetchParams,
    total: state.intentions.following.total,
    checkedIds: state.intentions.following.checkedIds,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      showModal,
      fetch,
      batchDestroy,
      showNotification,
    }, dispatch, 'following')
  })
)
export default class Toolbar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    checkedIds: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    showModal: PropTypes.func.isRequired,
    fetch: PropTypes.func.isRequired,
    batchDestroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired
  }

  handleAssign = () => {
    if (this.props.checkedIds.length <= 0) {
      return this.props.showNotification({
        type: 'warning',
        message: '请先选择要分配的意向',
      })
    }
    this.props.showModal('intentionAssign')
  }

  handleNew = type => () => {
    this.props.showModal('intentionEdit', { type })
  }

  handleSort = ({ orderField, orderBy }) => () => {
    const { fetchParams, fetch } = this.props
    fetch('following', { ...fetchParams, orderField, orderBy }, true)
  }

  handleDelete = () => {
    if (this.props.checkedIds.length <= 0) {
      return this.props.showNotification({
        type: 'warning',
        message: '请先选择要删除的意向',
      })
    }
    const { batchDestroy, checkedIds } = this.props
    batchDestroy(checkedIds)
  }

  handleImport = () => {
    this.props.showModal('intentionImport')
  }

  handleExport = () => {
    const { fetchParams, currentUser } = this.props
    let queryObj = {
      AutobotsToken: currentUser.token,
      report_type: 'intention'
    }
    if (fetchParams) {
      queryObj = {
        ...queryObj,
        ...decamelizeKeys(fetchParams)
      }
    }
    const queryString = qs.stringify(queryObj, { arrayFormat: 'brackets' })

    return `${config.serverUrl}${config.basePath}/reports/new?${queryString}`
  }

  renderSortButtons() {
    const fields = [
      { key: 'id', name: '创建时间' },
      { key: 'due_time', name: '下次跟进时间' },
    ]

    const { fetchParams } = this.props

    return fields.map((field) => (
      <SortButton key={field.key} field={field} query={fetchParams} onSort={this.handleSort} />
    ))
  }

  render() {
    const { total, checkedIds } = this.props

    return (
      <Segment>
        <Row>
          <Col span="10">
            <Button.Group>
              {this.renderSortButtons()}
            </Button.Group>
            <span className={styles.total}>
              共{total}条意向
            </span>
          </Col>
          <Col span="12" offset="2">
            <Row type="flex" justify="end" className={styles.buttons}>
              {can('全部客户管理') &&
                <Popconfirm
                  title={'确认删除选中' + checkedIds.length + '的条意向'}
                  onConfirm={this.handleDelete}
                >
                  <Button size="large"> 批量删除</Button>
                </Popconfirm>
              }
              <Button size="large" onClick={this.handleAssign}> 批量分配</Button>
              <Button size="large" onClick={this.handleImport}> 批量导入 </Button>
              {can('全部客户管理') &&
                <a className="ant-btn ant-btn-lg" href={this.handleExport()}>意向导出</a>
              }
            </Row>
          </Col>
        </Row>
      </Segment>
    )
  }
}
