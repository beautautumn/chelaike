import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetch, changeCheckedIds } from 'redux/modules/intentions'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Segment } from 'components'
import can from 'helpers/can'
import Helmet from 'react-helmet'
import styles from './List.scss'
import Operations from './Operations'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination } from 'antd'
import History from './History'
import Basic from './Basic'

function canAssign(intention) {
  const authorities = {
    seek: '求购客户管理',
    sale: '出售客户管理'
  }
  return can(authorities[intention.intentionType])
}

function canPush(intention) {
  if (can('全部客户管理')) return true

  if (intention.intentionType === 'sale') {
    return can('出售客户跟进')
  }
  return can('求购客户跟进')
}

function canShare(user, intention) {
  return !intention.shared && intention.assigneeId === user.id
}

@connect(
  state => ({
    intentions: visibleEntitiesSelector('intentions')(state, state.intentions.following.ids),
    checkedIds: state.intentions.following.checkedIds,
    fetchParams: state.intentions.following.fetchParams,
    total: state.intentions.following.total,
    fetching: state.intentions.following.fetching,
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
    }, dispatch, 'following')
  })
)
export default class List extends Component {
  static propTypes = {
    intentions: PropTypes.array.isRequired,
    checkedIds: PropTypes.array.isRequired,
    fetchParams: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    end: PropTypes.bool,
    total: PropTypes.number.isRequired,
    enumValues: PropTypes.object.isRequired,
    channelsById: PropTypes.object,
    intentionLevelsById: PropTypes.object,
    usersById: PropTypes.object,
    intentionPushHistoriesById: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    changeCheckedIds: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetch('following',
                     { page: 1, orderBy: 'desc', orderField: 'id', perPage: PAGE_SIZE },
                     true)
  }


  handleEdit = id => () => {
    this.props.showModal('intentionEdit', { id })
  }

  handlePush = id => () => {
    this.props.showModal('intentionPush', { id })
  }

  handleShare = id => () => {
    this.props.showModal('intentionShare', { id })
  }

  handlePage = (page) => {
    const { fetchParams, fetch, changeCheckedIds } = this.props
    fetch('following', { ...fetchParams, page }).then(() => {
      window.scrollTo(0, 0)
    })
    changeCheckedIds([])
  }

  handleMoreHistory = intentionId => event => {
    event.preventDefault()
    this.props.showModal('pushHistory', { intentionId })
  }

  render() {
    const {
      currentUser, enumValues, intentions, total, fetchParams,
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
          <Operations
            intention={intention}
            currentUser={currentUser}
            canPush={canPush(intention)}
            canShare={canShare(currentUser, intention)}
            handleEdit={this.handleEdit}
            handlePush={this.handlePush}
            handleShare={this.handleShare}
          />
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
      getCheckboxProps: intention => ({
        disabled: !canAssign(intention)
      })
    }

    return (
      <Segment>
        <Helmet title="客户跟踪" />
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
