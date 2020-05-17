import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import {
  fetch,
  recive,
  changeCheckedIds,
} from 'redux/modules/intentions'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination, Popconfirm } from 'antd'
import History from '../../FollowingPage/List/History'
import Basic from '../../FollowingPage/List/Basic'
import styles from '../../FollowingPage/List/List.scss'

@connect(
  state => ({
    intentions: visibleEntitiesSelector('intentions')(state, state.intentions.recovery.ids),
    checkedIds: state.intentions.recovery.checkedIds,
    fetchParams: state.intentions.recovery.fetchParams,
    total: state.intentions.recovery.total,
    fetching: state.intentions.recovery.fetching,
    channelsById: state.entities.channels,
    intentionLevelsById: state.entities.intentionLevels,
    usersById: state.entities.users,
    intentionPushHistoriesById: state.entities.intentionPushHistories,
    enumValues: state.enumValues,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      changeCheckedIds,
      showModal,
      recive
    }, dispatch, 'recovery')
  })
)
export default class List extends Component {
  static propTypes = {
    intentions: PropTypes.array.isRequired,
    checkedIds: PropTypes.array.isRequired,
    fetchParams: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    total: PropTypes.number.isRequired,
    enumValues: PropTypes.object.isRequired,
    channelsById: PropTypes.object,
    intentionLevelsById: PropTypes.object,
    usersById: PropTypes.object,
    intentionPushHistoriesById: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetch('recovery',
                     { page: 1, orderBy: 'desc', orderField: 'id', perPage: PAGE_SIZE },
                     true)
  }

  handleRecive = id => () => {
    this.props.recive({ intentionIds: [id] })
  }

  handleMoreHistory = intentionId => event => {
    event.preventDefault()
    this.props.showModal('pushHistory', { intentionId })
  }

  handlePage = (page) => {
    const { fetchParams, fetch, changeCheckedIds } = this.props
    fetch('following', { ...fetchParams, page }).then(() => {
      window.scrollTo(0, 0)
    })
    changeCheckedIds([])
  }

  render() {
    const {
      enumValues, intentions, total, fetchParams,
      intentionPushHistoriesById, usersById, channelsById, intentionLevelsById,
      changeCheckedIds, checkedIds,
    } = this.props

    const columns = [
      {
        key: 'customerName',
        dataIndex: 'customerName',
        title: '客户名称',
        width: 120,
      },
      {
        key: 'state',
        dataIndex: 'state',
        title: '意向状态',
        width: 100,
        render: text => enumValues.intention.state[text]
      },
      {
        key: 'basic',
        title: '基本信息',
        width: 350,
        render: (text, intention) => (
          <Basic
            intention={intention}
            channelsById={channelsById}
            usersById={usersById}
            intentionLevelsById={intentionLevelsById}
          />
        )
      },
      {
        key: 'intentionNote',
        dataIndex: 'intentionNote',
        title: '备注',
        width: 200,
      },
      {
        key: 'checkedCount',
        dataIndex: 'checkedCount',
        title: '到店',
        width: 60,
      },
      {
        key: 'history',
        title: '跟进历史',
        render: (text, intention) => (
          <History
            intention={intention}
            intentionPushHistoriesById={intentionPushHistoriesById}
            usersById={usersById}
            handleMoreHistory={this.handleMoreHistory}
          />
        )
      },
      {
        key: 'operation',
        width: 60,
        title: '操作',
        render: (text, intention) => (
          <Popconfirm
            title={`确认领取 ${intention.customerName || intention.customerPhone} 的意向？`}
            onConfirm={this.handleRecive(intention.id)}
          >
            <a>领取</a>
          </Popconfirm>
        )
      }
    ]

    const paginationProps = {
      pageSize: PAGE_SIZE,
      current: +fetchParams.page,
      total,
      onChange: this.handlePage
    }

    const rowSelection = {
      selectedRowKeys: checkedIds,
      onChange: changeCheckedIds,
    }

    return (
      <Segment>
        <Helmet title="意向回收" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          rowKey={car => car.id}
          rowSelection={rowSelection}
          columns={columns}
          dataSource={intentions}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
