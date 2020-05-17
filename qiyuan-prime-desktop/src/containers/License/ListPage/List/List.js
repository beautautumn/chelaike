import React, { Component, PropTypes } from 'react'
import { Segment, AlignedList, CarListImage, CarListBasicInfo } from 'components'
import { acquisitionPriceText } from 'helpers/car'
import date from 'helpers/date'
import { Table, Pagination } from 'antd'
import { PAGE_SIZE } from 'constants'
import can from 'helpers/can'
import LicenseInfo from './LicenseInfo'
import Operations from './Operations'
import styles from './List.scss'

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
    total: PropTypes.number
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
        key: 'license',
        render: (text, car) => (
          <LicenseInfo
            car={car}
            transfersById={transfersById}
          />
        )
      },
      {
        key: 'operations',
        width: 68,
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
