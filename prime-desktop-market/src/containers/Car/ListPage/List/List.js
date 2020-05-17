import React, { Component, PropTypes } from 'react'
import { AlignedList, StockAge, CarListImage, CarListBasicInfo, Segment } from 'components'
import { price, acquisitionPriceText, computeWarningLevel } from 'helpers/car'
import date from 'helpers/date'
import { Table, Pagination } from 'antd'
import { PAGE_SIZE } from 'constants'
import Operations from './Operations'
import can from 'helpers/can'
import styles from './List.scss'
import Helmet from 'react-helmet'

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
    cars: PropTypes.array,
    transfersById: PropTypes.object,
    shopsById: PropTypes.object,
    usersById: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    handleDestroy: PropTypes.func.isRequired,
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
      handleDestroy,
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
        width: 320,
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
        key: 'synchronization',
        width: 73,
        dataIndex: 'syncStateText',
        className: styles.textCenter
      },
      {
        key: 'stockWarning',
        width: 73,
        className: styles.textCenter,
        render: (text, car) => <StockAge car={car} />
      },
      {
        key: 'state',
        width: 94,
        className: styles.textCenter,
        render: (text, car) => <State car={car} enumValues={enumValues} />
      },
      {
        key: 'operation',
        width: 68,
        render: (text, car) => (
          <Operations
            car={car}
            currentUser={currentUser}
            handleDestroy={handleDestroy}
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
      <Segment>
        <Helmet title="在库车辆" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          showHeader={false}
          rowKey={car => car.id}
          rowClassName={car => styles[computeWarningLevel(car)]}
          columns={columns}
          dataSource={cars}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
