import React, { Component, PropTypes } from 'react'
import {
  licensedInfoText,
  displacement
} from 'helpers/car'
import date from 'helpers/date'
import get from 'lodash/get'
import { Row, Col, Tag, Tooltip } from 'antd'
import { AlignedList } from 'components'
import styles from './CarListBasicInfo.scss'

function LeftCol({ car, shopsById }) {
  const data = [
    { label: '分店：', text: car.shop && shopsById[car.shop].name },
    { label: '上牌日期：', text: licensedInfoText(car) },
  ]
  return (
    <Col span="12">
      <AlignedList data={data} dashed />
    </Col>
  )
}

function RightCol({ car, transfer }) {
  const data = [
    { label: '库存号：', text: car.stockNumber },
    { label: '车牌号：', text: get(transfer, 'currentPlateNumber') },
  ]

  return (
    <Col span="11" offset="1">
      <AlignedList data={data} dashed />
    </Col>
  )
}

function CarTag({ label, value }) {
  return (
    <Tooltip title={label}>
      <Tag color="blue">{value}</Tag>
    </Tooltip>
  )
}

export default class CarListBasicInfo extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    shopsById: PropTypes.object,
    transfersById: PropTypes.object,
    enumValues: PropTypes.object.isRequired
  }

  render() {
    const { car, shopsById, transfersById, enumValues } = this.props

    let transfer
    if (transfersById) {
      transfer = transfersById[car.acquisitionTransfer]
    }

    return (
      <div>
        <h5>
          <a className={styles.title} href={`/cars/${car.id}`} target="_blank">{car.systemName}</a>
          {car.reserved && <Tag color="green">已预定</Tag>}
        </h5>
        <Row>
          <LeftCol car={car} shopsById={shopsById} />
          <RightCol car={car} transfer={transfer} enumValues={enumValues} />
        </Row>
        <Row className={styles.tagsRow}>
          <Col>
            {car.vin && <CarTag label="车架号" value={car.vin} />}
            {car.manufacturedAt &&
              <CarTag label="出厂年月" value={date(car.manufacturedAt, 'short')} />
            }
            {car.mileage && <CarTag label="里程" value={car.mileage + '万公里'} />}
            {car.displacement && <CarTag label="排量" value={displacement(car)} />}
            {car.exteriorColor && <CarTag label="外观" value={car.exteriorColor} />}
            {car.transmission &&
              <CarTag label="变速箱" value={enumValues.car.transmission[car.transmission]} />
            }
          </Col>
        </Row>
      </div>
    )
  }
}
