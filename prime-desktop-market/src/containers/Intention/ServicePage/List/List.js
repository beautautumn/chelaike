import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import {
  fetch,
  destroy,
} from 'redux/modules/intentions'
import { show as showModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import Basic from './Basic'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination, Popconfirm } from 'antd'
import date from 'helpers/date'
import styles from '../../FollowingPage/List/List.scss'
import get from 'lodash/get'

@connect(
  state => ({
    intentions: visibleEntitiesSelector('intentions')(state, state.intentions.service.ids),
    destroyed: state.intentions.service.destroyed,
    fetchParams: state.intentions.service.fetchParams,
    end: state.intentions.service.end,
    total: state.intentions.service.total,
    fetching: state.intentions.service.fetching,
    channelsById: state.entities.channels,
    usersById: state.entities.users,
    enumValues: state.enumValues
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      destroy,
      showModal,
      showNotification,
    }, dispatch, 'service')
  })
)
export default class List extends Component {
  static propTypes = {
    intentions: PropTypes.array.isRequired,
    destroyed: PropTypes.bool,
    fetchParams: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    end: PropTypes.bool,
    total: PropTypes.number.isRequired,
    enumValues: PropTypes.object.isRequired,
    channelsById: PropTypes.object,
    usersById: PropTypes.object,
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired
  }

  componentDidMount() {
    this.props.fetch('service',
                     { page: 1, orderBy: 'desc', orderField: 'id', perPage: PAGE_SIZE },
                     true)
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '删除成功',
      })
    }
  }

  handleEdit = id => () => {
    this.props.showModal('intentionEdit', { id })
  }

  handleDestroy = intention => () => {
    this.props.destroy(intention.id)
  }

  handlePage = (page) => {
    const { fetchParams, fetch } = this.props
    fetch('service', { ...fetchParams, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  render() {
    const { enumValues, intentions, total, fetchParams, usersById, channelsById } = this.props

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
          />
        )
      },
      {
        key: 'creator',
        title: '录入人',
        width: 90,
        render: (text, intention) => {
          const creator = get(usersById, intention.creatorId)
          return creator && creator.name
        }
      },
      {
        key: 'intentionNote',
        dataIndex: 'intentionNote',
        title: '备注',
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: '创建日期',
        width: 120,
        render: text => (date(text))
      },
      {
        key: 'operation',
        width: 90,
        title: '操作',
        render: (text, intention) => (
          <span>
            <a href="#" onClick={this.handleEdit(intention.id)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm
              title={`确认删除 ${intention.customerName || intention.customerPhone} 的意向？`}
              onConfirm={this.handleDestroy(intention)}
            >
              <a>删除</a>
            </Popconfirm>
          </span>

        )
      }
    ]

    const paginationProps = {
      pageSize: PAGE_SIZE,
      current: +fetchParams.page,
      total,
      onChange: this.handlePage
    }

    return (
      <Segment>
        <Helmet title="坐席录入" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          rowKey={car => car.id}
          columns={columns}
          dataSource={intentions}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
