import React from 'react'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'
import { Table } from 'antd'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { exportLink } from 'helpers/car'
import date from 'helpers/date'
import { PureComponent } from 'react-pure-render'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { fetchCustomerReports } from 'redux/modules/export'
import ExportCustomerSearchForm from './Forms/ExportCustomerSearchForm'

const defaultQuery = {
  query: {},
  page: 1,
  perPage: PAGE_SIZE
}

@connect(
  state => {
    const { customerReports: { ids, query, total } } = state.export
    return {
      query,
      total,
      currentUser: state.auth.user,
      reports: visibleEntitiesSelector('exportCustomerReports')(state, ids)
    }
  },
  (dispatch) => ({
    ...bindActionCreators({
      fetchCustomerReports
    }, dispatch)
  })
)
export default class ExportCustomer extends PureComponent {

  onSearch = (values) => {
    const { fetchCustomerReports } = this.props
    fetchCustomerReports({ ...defaultQuery, query: { ...values } }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onResetSearch = () => {
    const { fetchCustomerReports } = this.props
    fetchCustomerReports(defaultQuery).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onExport = (values) => {
    const { currentUser } = this.props
    window.location.href = exportLink(values, currentUser, 'bm_intention')
  }

  onPageChanged = (page) => {
    const { fetchCustomerReports, query } = this.props
    fetchCustomerReports({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  componentWillMount() {
    this.onResetSearch()
  }

  render() {
    const columns = [
      {
        key: 'customerId',
        dataIndex: 'customerId',
        title: '客户编号',
        width: 100
      },
      {
        key: 'shopCity',
        dataIndex: 'shopCity',
        title: '所属城市',
        width: 100
      },
      {
        key: 'shopName',
        dataIndex: 'shopName',
        title: '所属门店',
        width: 100
      },
      {
        key: 'assigneeName',
        dataIndex: 'assigneeName',
        title: '业务员',
        width: 100
      },
      {
        key: 'customerName',
        dataIndex: 'customerName',
        title: '客户名称',
        width: 100
      },
      {
        key: 'customerPhone',
        dataIndex: 'customerPhone',
        title: '联系电话',
        width: 100
      },
      {
        key: 'intentionPushDays',
        dataIndex: 'intentionPushDays',
        title: '跟进天数',
        width: 100
      },
      {
        key: 'intentionResult',
        dataIndex: 'stateText',
        title: '跟进结果',
        width: 100
      },
      {
        key: 'seekDescription',
        dataIndex: 'seekDescription',
        title: '求购车辆',
        width: 100
      },
      {
        key: 'priceRangeText',
        dataIndex: 'priceRangeText',
        title: '预算',
        width: 100
      },
      {
        key: 'stateText',
        dataIndex: 'stateText',
        title: '意向状态',
        width: 100
      },
      {
        key: 'channelName',
        dataIndex: 'channelName',
        title: '客户来源',
        width: 100
      },
      {
        key: 'intentionLevelName',
        dataIndex: 'intentionLevelName',
        title: '客户级别',
        width: 100
      },
      {
        key: 'city',
        dataIndex: 'city',
        title: '客户所属区域',
        width: 100
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: '创建日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'matchedCars',
        dataIndex: 'matchedCars',
        title: '匹配车辆',
        width: 100
      },
      {
        key: 'intentionCompleted',
        dataIndex: 'intentionCompleted',
        title: '是否成交',
        width: 100
      },
      {
        key: 'checkedOut',
        dataIndex: 'checkedOut',
        title: '是否到店',
        width: 100
      },
      {
        key: 'expired',
        dataIndex: 'expired',
        title: '是否过期',
        width: 100,
        render: (text) => (text ? '是' : '否')
      },
      {
        key: 'latestPushHistoryNote',
        dataIndex: 'latestPushHistoryNote',
        title: '最后跟进描述',
        width: 100
      },
      {
        key: 'latestPushHistoryCreatedAt',
        dataIndex: 'latestPushHistoryCreatedAt',
        title: '最后跟进日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'pushHistoriesText',
        dataIndex: 'pushHistoriesText',
        title: '跟进历史',
        width: 500,
        render: (text) => (<pre>{text}</pre>)
      }
    ]
    const { query, total, reports, enumValues } = this.props
    const pagination = {
      pageSize: PAGE_SIZE,
      current: +query.page,
      total,
      onChange: this.onPageChanged
    }
    return (
      <div>
        <Helmet title="客户数据导出" />
        <ExportCustomerSearchForm
          enumValues={enumValues}
          onSubmit={this.onSearch}
          onReset={this.onResetSearch}
          onExport={this.onExport}
        />
        <Segment className="ui segment">
          <Table
            columns={columns}
            scroll={{ x: 2600, y: 1200 }}
            dataSource={reports}
            rowKey={report => report.id}
            bordered
            pagination={pagination}
          />
        </Segment>
      </div>
    )
  }
}
