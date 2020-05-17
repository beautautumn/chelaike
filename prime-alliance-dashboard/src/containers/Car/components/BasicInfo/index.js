import React, { PropTypes } from 'react'
import {
  licensedInfoText,
  displacement,
} from 'helpers/car'
import date from 'helpers/date'
import get from 'lodash/get'
import { Row, Col, Tag, Tooltip } from 'antd'
import { AlignedList } from '@prime/components'
import styles from './style.scss'

function CarTag({ label, value }) {
  return (
    <Tooltip title={label}>
      <Tag color="blue">{value}</Tag>
    </Tooltip>
  )
}
CarTag.propTypes = {
  label: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
}

export default function BasicInfo({ car, enumValues }) {
  const leftData = [
    { label: '车商：', text: car.company.nickname },
    { label: '上牌日期：', text: licensedInfoText(car) },
  ]

  const rightData = [
    { label: '库存号：', text: car.stockNumber },
    { label: '车牌号：', text: get(car, 'acquisitionTransfer.currentPlateNumber') },
  ]

  return (
    <div>
      <h4 className={styles.title}>
        <a href={`/cars/${car.id}`} target="_blank">{car.systemName}</a>
        {car.reserved && !car.stockOutAt && <Tag color="green">已预定</Tag>}
      </h4>
      <Row>
        <Col span="12">
          <AlignedList data={leftData} dashed />
        </Col>
        <Col span="11" offset="1">
          <AlignedList data={rightData} dashed />
        </Col>
      </Row>
      <Row className={styles.tagsRow}>
        <Col>
          {car.vin && <CarTag label="车架号" value={car.vin} />}
          {car.manufacturedAt &&
            <CarTag label="出厂日期" value={date(car.manufacturedAt, 'short')} />
          }
          {car.mileage && <CarTag label="里程" value={`${car.mileage}万公里`} />}
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

BasicInfo.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}
