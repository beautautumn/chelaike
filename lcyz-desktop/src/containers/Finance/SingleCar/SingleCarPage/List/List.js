import React, { Component, PropTypes } from 'react'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination } from 'antd'
import styles from './List.scss'
import date from 'helpers/date'

export default class List extends Component {
  static propTypes = {
    costAndBenefitOfCars: PropTypes.array.isRequired,
    query: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    total: PropTypes.number.isRequired,
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    enumValues: PropTypes.object.isRequired,
  }

  componentDidMount() {
    const defaultQuery = {
      query: {},
      page: 1,
      perPage: 6,
      orderBy: 'desc',
      orderField: 'stock_out_at',
    }
    this.props.fetch(defaultQuery, true)
  }

  handlePage = (page) => {
    const { query, fetch } = this.props
    fetch({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  handleUpdateAcquistionPrice = record => () => {
    this.props.showModal('inStockPriceEditForFinance', { record })
  }

  handleUpdateClosingCost = record => () => {
    this.props.showModal('outStockPriceEditForFinance', { record })
  }

  handleUpdateFundRate = record => () => {
    this.props.showModal('fundRateEidtforFinance', { record })
  }

  handleUpdateFee = (record, category) => () => {
    this.props.showModal('costAndBenefitEditForFinance', { record, category })
  }

  handleUpdatePAR = (record, category) => () => {
    this.props.showModal('PaymentAndReceiptEditForFinance', { record, category })
  }

  price(value, unit) {
    return (value || 0) + unit
  }


  render() {
    const { query, total, costAndBenefitOfCars, enumValues } = this.props

    const price = this.price

    const columns = [
      {
        key: 'stockNumber',
        dataIndex: 'stockNumber',
        title: (<div className={styles.fixedColumnsHeader}>库存号</div>),
        width: 80,
        fixed: 'left',
      },
      {
        key: 'carInfo',
        title: '车型',
        render: (text, record) => (
          <div>
            <a href={`/cars/${record.carId}`} target="_blank">{record.name}</a>
            <div>车架号：{record.vin ? record.vin.substr(-8) : ''}</div>
          </div>
        ),
        width: 160,
        fixed: 'left',
      },
      {
        key: 'saleInfo',
        title: (<div><div>销售员／</div><div>出库日期</div></div>),
        render: (text, record) => (
          <div>
            <div>{record.sellInfo.seller}</div>
            <div>{date(record.sellInfo.date)}</div>
          </div>
        ),
        width: 100,
      },
      {
        key: 'acquisitionInfo',
        title: (<div><div>收购员／</div><div>入库日期</div></div>),
        render: (text, record) => (
          <div>
            <div>{record.acquisitionInfo.acquirer}</div>
            <div>{date(record.acquisitionInfo.date)}</div>
          </div>
        ),
        width: 100,
      },
      {
        key: 'acquisitionType',
        title: '收购类型',
        width: 70,
        render: (text, record) => (enumValues.car.acquisition_type[record.acquisitionType]),
      },
      {
        key: 'cost',
        title: '单车成本',
        children: [{
          key: 'acquisitionPriceWan',
          title: '入库价',
          render: (text, record) => (
            <a onClick={this.handleUpdateAcquistionPrice(record)}>
              {price(record.acquisitionPriceWan, '万')}
            </a>
          ),
        }, {
          key: 'paymentWan',
          title: '入库付款',
          render: (text, record) => (
            <a onClick={this.handleUpdatePAR(record, 'payment')}>
              {price(record.paymentWan, '万')}
            </a>
          ),
        }, {
          key: 'prepareCostYuan',
          title: '整备费用',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'prepare_cost')}>
              {price(record.prepareCostYuan, '元')}
            </a>
          ),
        }, {
          key: 'handlingChargeYuan',
          title: '手续费',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'handling_charge')}>
              {price(record.handlingChargeYuan, '元')}
            </a>
          ),
        }, {
          key: 'commissionYuan',
          title: '佣金',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'commission')}>
              {price(record.commissionYuan, '元')}
            </a>
          ),
        }, {
          key: 'percentageYuan',
          title: '提成／分成',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'percentage')}>
              {price(record.percentageYuan, '元')}
            </a>
          ),
        }, {
          key: 'fundCostYuan',
          title: '资金',
          render: (text, record) => (
            <a onClick={this.handleUpdateFundRate(record)}>
              {price(record.fundCostYuan, '元')}
            </a>
          ),
        }, {
          key: 'otherCostYuan',
          title: '其它',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'other_cost')}>
              {price(record.otherCostYuan, '元')}
            </a>
          ),
        }]
      },
      {
        key: 'income',
        title: '单车收益',
        children: [{
          key: 'closingCostWan',
          title: '出库价',
          render: (text, record) => {
            if (['sold', 'acquisition_refunded',
                 'alliance_stocked_out', 'alliance_refunded'].includes(record.state)) {
              return (
                <a onClick={this.handleUpdateClosingCost(record)}>
                  {price(record.closingCostWan, '万')}
                </a>
              )
            }
            return price(record.closingCostWan, '万')
          }
        }, {
          key: 'receiptWan',
          title: '出库收款',
          render: (text, record) => {
            if (['sold', 'acquisition_refunded',
                 'alliance_stocked_out', 'alliance_refunded'].includes(record.state)) {
              return (
                <a onClick={this.handleUpdatePAR(record, 'receipt')}>
                  {price(record.receiptWan, '万')}
                </a>
              )
            }
            return price(record.receiptWan, '万')
          }
        }, {
          key: 'otherProfitYuan',
          title: '其它',
          render: (text, record) => (
            <a onClick={this.handleUpdateFee(record, 'other_profit')}>
              {price(record.otherProfitYuan, '元')}
            </a>
          ),
        }]
      },
      {
        key: 'grossProfit',
        dataIndex: 'grossProfit',
        title: (<div className={styles.fixedColumnsHeader}>毛利</div>),
        fixed: 'right',
        width: 70,
      }, {
        key: 'grossMargin',
        dataIndex: 'grossMargin',
        title: '毛利率',
        fixed: 'right',
        width: 70,
      }, {
        key: 'netProfit',
        dataIndex: 'netProfit',
        title: '净利',
        fixed: 'right',
        width: 70,
      }, {
        key: 'netMargin',
        dataIndex: 'netMargin',
        title: '净利率',
        fixed: 'right',
        width: 70,
      }
    ]

    const paginationProps = {
      pageSize: PAGE_SIZE,
      current: +query.page,
      total,
      onChange: this.handlePage
    }

    return (
      <Segment>
        <Helmet title="单车成本于收益" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          rowKey={record => record.id}
          columns={columns}
          className={styles.costAndIncomeTable}
          dataSource={costAndBenefitOfCars}
          bordered
          pagination={paginationProps}
          scroll={{ x: 1677 }}
        />
      </Segment>
    )
  }
}
