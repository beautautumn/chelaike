import React, { PropTypes } from 'react'
import { Table, Pagination } from 'antd'
import { PAGE_SIZE } from 'config/constants'
import can from 'helpers/can'
import date from 'helpers/date'
import { price, computeWarningLevel } from 'helpers/car'
import Operations from './Operations'
import { AlignedList } from '@prime/components'
import { CarImage, Segment } from 'components'
import { StockAge, BasicInfo } from '../../components'
import get from 'lodash/get'
import styles from './style.scss'

function Price({ car }) {
  const data = [
    { label: '新车完税价：', text: price(car.newCarFinalPriceWan, '万') },
    { label: '展厅价：', text: price(car.showPriceWan, '万') },
  ]
  if (can('销售底价查看', null, car.shop)) {
    data.push({ label: '销售底价：', text: price(car.salesMinimunPriceWan, '万') })
  }
  data.push(
    { label: '网络价：', text: price(car.onlinePriceWan, '万') },
    { label: '联盟底价：', text: price(car.allianceMinimunPriceWan, '万') },
  )

  return <AlignedList data={data} dashed />
}
Price.propTypes = {
  car: PropTypes.object.isRequired,
}

function Acquisition({ car, enumValues }) {
  if (!can('收购信息查看', null, car.shop)) {
    return <span />
  }
  const data = [
    { label: '收购员：', text: get(car, 'acquirer.name') },
    { label: '收购类型：', text: enumValues.car.acquisition_type[car.acquisitionType] },
    { label: '收购日期：', text: date(car.acquiredAt) },
  ]
  return <AlignedList data={data} dashed />
}
Acquisition.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}

export default function List(props) {
  const {
    enumValues,
    cars,
    currentUser,
    query,
    total,
    handlePage,
    handleImageUpload,
  } = props

  const columns = [
    {
      key: 'cover',
      width: 136,
      render: (text, car) => <CarImage url={car.coverUrl} />,
    },
    {
      key: 'allianceCover',
      width: 136,
      render: (text, car) => <CarImage url={get(car, 'allianceImages[0].url')} />,
    },
    {
      key: 'basic',
      width: 320,
      render: (text, car) => (
        <BasicInfo car={car} enumValues={enumValues} />
      ),
    },
    {
      key: 'price',
      width: 163,
      render: (text, car) => <Price car={car} currentUser={currentUser} />,
    },
    {
      key: 'acquisition',
      width: 163,
      render: (text, car) => (
        <Acquisition car={car} currentUser={currentUser} enumValues={enumValues} />
      ),
    },
    {
      key: 'stockWarning',
      width: 73,
      render: (text, car) => <StockAge car={car} enumValues={enumValues} />,
    },
    {
      key: 'operationRecords',
      width: 105,
      render: (text, car) => (
        <div>
          {car.operationRecords && car.operationRecords.map((record) => {
            const opType = enumValues
              .operation_record
              .car_operation_type[record.operationRecordType] || record.operationRecordType
            return (
              <div>{date(record.createdAt)} {opType}<br /></div>
            )
          })}
        </div>
      ),
    },
    {
      key: 'operation',
      width: 57,
      render: (text, car) => (
        <Operations
          car={car}
          currentUser={currentUser}
          handleImageUpload={handleImageUpload}
        />
      ),
    },
  ]

  const paginationProps = {
    pageSize: PAGE_SIZE,
    current: +query.page,
    total,
    onChange: handlePage,
  }

  return (
    <Segment>
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

List.propTypes = {
  enumValues: PropTypes.object.isRequired,
  cars: PropTypes.array.isRequired,
  currentUser: PropTypes.object.isRequired,
  handlePage: PropTypes.func.isRequired,
  query: PropTypes.object.isRequired,
  total: PropTypes.number,
  handleImageUpload: PropTypes.func.isRequired,
}
