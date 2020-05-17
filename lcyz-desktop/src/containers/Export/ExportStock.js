import React from 'react'
import date from 'helpers/date'
import Helmet from 'react-helmet'
import { Table } from 'antd'
import { Segment } from 'components'
import { PAGE_SIZE } from 'constants'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { exportLink } from 'helpers/car'
import { PureComponent } from 'react-pure-render'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { fetchStockReports } from 'redux/modules/export'
import ExportStockSearchForm from './Forms/ExportStockSearchForm'

const defaultQuery = {
  query: {},
  page: 1,
  perPage: PAGE_SIZE
}

@connect(
  state => {
    const { stockReports: { ids, query, total } } = state.export
    return {
      query,
      total,
      currentUser: state.auth.user,
      reports: visibleEntitiesSelector('exportStockReports')(state, ids)
    }
  },
  (dispatch) => ({
    ...bindActionCreators({
      fetchStockReports
    }, dispatch)
  })
)
export default class ExportStock extends PureComponent {

  onSearch = (values) => {
    const { fetchStockReports } = this.props
    fetchStockReports({ ...defaultQuery, query: { ...values } }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onResetSearch = () => {
    const { fetchStockReports } = this.props
    fetchStockReports(defaultQuery).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onExport = (values) => {
    const { currentUser } = this.props
    window.location.href = exportLink(values, currentUser, 'bm_cars')
  }

  onPageChanged = (page) => {
    const { fetchStockReports, query } = this.props
    fetchStockReports({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  componentWillMount() {
    this.onResetSearch()
  }

  render() {
    const columns = [
      {
        key: 'id',
        dataIndex: 'id',
        title: '车源编号',
        width: 100
      },
      {
        key: 'shopCity',
        dataIndex: 'shopCity',
        title: '所属城市',
        width: 100
      },
      {
        key: 'acquirerName',
        dataIndex: 'acquirerName',
        title: '车源负责人',
        width: 100
      },
      {
        key: 'ownerCompanyName',
        dataIndex: 'ownerCompanyName',
        title: '所属车商',
        width: 100
      },
      {
        key: 'companyName',
        dataIndex: 'companyName',
        title: '车商归属市场',
        width: 100
      },
      {
        key: 'brandName',
        dataIndex: 'brandName',
        title: '品牌',
        width: 100
      },
      {
        key: 'styleName',
        dataIndex: 'styleName',
        title: '车型',
        width: 100
      },
      {
        key: 'exteriorColor',
        dataIndex: 'exteriorColor',
        title: '颜色',
        width: 100
      },
      {
        key: 'age',
        dataIndex: 'age',
        title: '车龄',
        width: 100
      },
      {
        key: 'mileage',
        dataIndex: 'mileage',
        title: '公里数',
        width: 100
      },
      {
        key: 'displacement',
        dataIndex: 'displacement',
        title: '排量',
        width: 100
      },
      {
        key: 'showPriceWan',
        dataIndex: 'showPriceWan',
        title: '车价',
        width: 100
      },
      {
        key: 'licensedAt',
        dataIndex: 'licensedAt',
        title: '初登日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'stockAgeDays',
        dataIndex: 'stockAgeDays',
        title: '库存天数',
        width: 100
      },
      {
        key: 'stateText',
        dataIndex: 'stateText',
        title: '车辆状态',
        width: 100
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: '入库日期',
        width: 100,
        render: (text) => date(text, 'full')
      },
      {
        key: 'stockOutAt',
        dataIndex: 'stockOutAt',
        title: '出库日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'salesType',
        dataIndex: 'salesType',
        title: '成交状态',
        width: 100
      }
    ]
    const { query, total, reports } = this.props
    const pagination = {
      pageSize: PAGE_SIZE,
      current: +query.page,
      total,
      onChange: this.onPageChanged
    }
    return (
      <div>
        <Helmet title="库存数据导出" />
        <ExportStockSearchForm
          onSubmit={this.onSearch}
          onReset={this.onResetSearch}
          onExport={this.onExport}
        />
        <Segment className="ui segment">
          <Table
            columns={columns}
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

