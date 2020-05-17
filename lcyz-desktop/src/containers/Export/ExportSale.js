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
import { fetchSaleReports } from 'redux/modules/export'
import ExportSaleSearchForm from './Forms/ExportSaleSearchForm'

const defaultQuery = {
  query: {},
  page: 1,
  perPage: PAGE_SIZE
}

@connect(
  state => {
    const { saleReports: { ids, query, total } } = state.export
    return {
      query,
      total,
      currentUser: state.auth.user,
      reports: visibleEntitiesSelector('exportSaleReports')(state, ids)
    }
  },
  (dispatch) => ({
    ...bindActionCreators({
      fetchSaleReports
    }, dispatch)
  })
)
export default class ExportSale extends PureComponent {

  onSearch = (values) => {
    const { fetchSaleReports } = this.props
    fetchSaleReports({ ...defaultQuery, query: { ...values } }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onResetSearch = () => {
    const { fetchSaleReports } = this.props
    fetchSaleReports(defaultQuery).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onExport = (values) => {
    const { currentUser } = this.props
    window.location.href = exportLink(values, currentUser, 'bm_sold_out')
  }

  onPageChanged = (page) => {
    const { fetchSaleReports, query } = this.props
    fetchSaleReports({ ...query, page }).then(() => {
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
        key: 'shopName',
        dataIndex: 'shopName',
        title: '所属门店',
        width: 100
      },
      {
        key: 'sellerName',
        dataIndex: 'sellerName',
        title: '业务员',
        width: 100
      },
      {
        key: 'companyName',
        dataIndex: 'companyName',
        title: '所属车商',
        width: 100
      },
      {
        key: 'companyShopName',
        dataIndex: 'companyShopName',
        title: '车商归属市场',
        width: 100
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: '成交日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'carBrandName',
        dataIndex: 'carBrandName',
        title: '品牌',
        width: 100
      },
      {
        key: 'carSeriesName',
        dataIndex: 'carSeriesName',
        title: '车型',
        width: 100
      },
      {
        key: 'carExteriorColor',
        dataIndex: 'carExteriorColor',
        title: '颜色',
        width: 100
      },
      {
        key: 'carAge',
        dataIndex: 'carAge',
        title: '车龄',
        width: 100
      },
      {
        key: 'carMileage',
        dataIndex: 'carMileage',
        title: '公里数',
        width: 100
      },
      {
        key: 'carDisplacementText',
        dataIndex: 'carDisplacementText',
        title: '排量',
        width: 100
      },
      {
        key: 'carShowPriceWan',
        dataIndex: 'carShowPriceWan',
        title: '价格',
        width: 100
      },
      {
        key: 'carLicensedAt',
        dataIndex: 'carLicensedAt',
        title: '初登日期',
        width: 100,
        render: (text) => date(text, 'default')
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
        key: 'customerChannelName',
        dataIndex: 'customerChannelName',
        title: '客户来源',
        width: 100
      },
      {
        key: 'customerCreatedAt',
        dataIndex: 'customerCreatedAt',
        title: '客户创建日期',
        width: 100,
        render: (text) => date(text, 'default')
      },
      {
        key: 'customerPushHistoryDays',
        dataIndex: 'customerPushHistoryDays',
        title: '客户跟进天数',
        width: 100
      },
      {
        key: 'mortgaged',
        dataIndex: 'mortgaged',
        title: '是否按揭',
        width: 100,
        render: (text) => (text ? '是' : '否')
      },
      {
        key: 'mortgageCompanyName',
        dataIndex: 'mortgageCompanyName',
        title: '按揭公司',
        width: 100
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
        <Helmet title="销售数据导出" />
        <ExportSaleSearchForm
          enumValues={enumValues}
          onSubmit={this.onSearch}
          onReset={this.onResetSearch}
          onExport={this.onExport}
        />
        <Segment className="ui segment">
          <Table
            columns={columns}
            scroll={{ x: 2200, y: 1200 }}
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
