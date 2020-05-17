import React, { Component, PropTypes } from 'react'
import { Segment, AlignedList, StockAge, CarListImage, CarListBasicInfo } from 'components'
import { price, acquisitionPriceText } from 'helpers/car'
import date from 'helpers/date'
import can from 'helpers/can'
import { Table, Pagination } from 'antd'
import { PAGE_SIZE } from 'constants'
import Operations from './Operations'
import styles from './List.scss'
import get from 'lodash/get'

function Price({ car }) {
  const data = [
    { label: '新车完税价：', text: price(car.newCarFinalPriceWan, '万') },
    { label: '展厅价：', text: price(car.showPriceWan, '万') }
  ]
  if (can('销售底价查看', null, car.shop)) {
    data.push({ label: '销售底价：', text: price(car.salesMinimunPriceWan, '万') })
  }
  return <AlignedList data={data} dashed />
}

function Acquisition({ car, usersById, enumValues }) {
  if (!can('收购信息查看', null, car.shop)) {
    return <span />
  }
  const [acquisitionPriceLabel, acquisitionPrice] = acquisitionPriceText(car)
  const data = [
    { label: '收购员：', text: car.acquirer && usersById[car.acquirer].name }
  ]
  if (can('收购价格查看', null, car.shop)) {
    data.push({ label: `${acquisitionPriceLabel}：`, text: acquisitionPrice })
  }
  data.push(
    { label: '收购类型：', text: enumValues.car.acquisition_type[car.acquisitionType] },
    { label: '收购日期：', text: date(car.acquiredAt) }
  )
  return <AlignedList data={data} dashed />
}

function StockOut({ car }) {
  let data
  switch (get(car, 'stockOutInventory.stockOutInventoryType')) {
    case 'sold':
      if (can('销售成交信息查看', null, car.shop)) {
        data = [
          { label: '销售员：', text: get(car, 'stockOutInventory.seller.name') },
          { label: '成交价：', text: price(get(car, 'stockOutInventory.closingCostWan'), '万') },
          { label: '日期：', text: date(get(car, 'stockOutInventory.completedAt')) }
        ]
      } else {
        data = []
      }
      break
    case 'acquisition_refunded':
      data = [
        { label: '操作员：', text: get(car, 'stockOutInventory.operator.name') },
        { label: '日期：', text: date(get(car, 'stockOutInventory.refundedAt')) }
      ]
      break
    case 'driven_back':
      data = [
        { label: '操作员：', text: get(car, 'stockOutInventory.operator.name') },
        { label: '日期：', text: date(get(car, 'stockOutInventory.drivenBackAt')) }
      ]
      break
    default:
      data = []
  }
  return <AlignedList data={data} dashed />
}

function State({ car, enumValues }) {
  return (
    <div>
      {enumValues.car.state[car.state]}
      <br />
      {car.stateNote && <span>({car.stateNote})</span>}
    </div>
  )
}

export default class List extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    cars: PropTypes.array.isRequired,
    transfersById: PropTypes.object,
    usersById: PropTypes.object,
    shopsById: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    handleShowModal: PropTypes.func.isRequired,
    handlePage: PropTypes.func.isRequired,
    query: PropTypes.object.isRequired,
    total: PropTypes.number,
  }

  render() {
    const {
      enumValues,
      cars,
      transfersById,
      usersById,
      shopsById,
      currentUser,
      query,
      total,
      handlePage,
      handleShowModal
    } = this.props

    const columns = [
      {
        key: 'cover',
        width: 136,
        render: (text, car) => <CarListImage car={car} />
      },
      {
        key: 'basic',
        width: 300,
        render: (text, car) => (
          <CarListBasicInfo
            car={car}
            shopsById={shopsById}
            transfersById={transfersById}
            enumValues={enumValues}
          />
        )
      },
      {
        key: 'price',
        width: 163,
        render: (text, car) => <Price car={car} currentUser={currentUser} />
      },
      {
        key: 'acquisition',
        width: 163,
        render: (text, car) => (
          <Acquisition
            car={car}
            currentUser={currentUser}
            usersById={usersById}
            enumValues={enumValues}
          />
        )
      },
      {
        key: 'stockOut',
        width: 140,
        render: (text, car) => (
          <StockOut car={car} />
        )
      },
      {
        key: 'stockWarning',
        width: 45,
        className: styles.textCenter,
        render: (text, car) => <StockAge car={car} />
      },
      {
        key: 'state',
        className: styles.textCenter,
        render: (text, car) => <State car={car} enumValues={enumValues} />
      },
      {
        key: 'operation',
        width: 58,
        render: (text, car) => (
          <Operations
            car={car}
            currentUser={currentUser}
            handleShowModal={handleShowModal}
          />
        )
      }
    ]

    const paginationProps = {
      pageSize: PAGE_SIZE,
      current: +query.page,
      total,
      onChange: handlePage
    }

    return (
      <Segment className="ui segment">
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          showHeader={false}
          rowKey={car => car.id}
          columns={columns}
          dataSource={cars}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
