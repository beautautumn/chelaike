import React, { Component, PropTypes } from 'react'
import { Row, Col, Progress } from 'antd'
import { AlignedList } from 'components'
import date from 'helpers/date'
import { transferRecordEstimatedTime } from 'helpers/car'
import styles from './List.scss'

function LeftCol({ acquisitionTransfer }) {
  const data = [
    { label: '收购手续状态：', text: acquisitionTransfer.stateText },
    { label: '落户人：', text: acquisitionTransfer.transferRecevier },
    { label: '预计时间：', text: date(transferRecordEstimatedTime(acquisitionTransfer)) }
  ]
  return (
    <Col span="11">
      <AlignedList data={data} dashed />
    </Col>
  )
}

function RightCol({ saleTransfer }) {
  const data = [
    { label: '销售手续状态：', text: saleTransfer.stateText },
    { label: '落户人：', text: saleTransfer.newOwner },
    { label: '预计时间：', text: date(transferRecordEstimatedTime(saleTransfer)) }
  ]
  return (
    <Col span="11" offset="1">
      <AlignedList data={data} dashed />
    </Col>
  )
}

function CompleteProgress({ finished, total }) {
  const percentage = finished / total * 100
  const status = percentage < 100 ? 'exception' : 'normal'
  const format = () => `${finished}/${total}`

  return <Progress type="line" percent={percentage} status={status} format={format} />
}

export default class LicenseInfo extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    transfersById: PropTypes.object
  }

  render() {
    const { car, transfersById } = this.props
    const acquisitionTransfer = transfersById[car.acquisitionTransfer]
    const saleTransfer = transfersById[car.saleTransfer]

    return (
      <div>
        <Row>
          <LeftCol acquisitionTransfer={acquisitionTransfer} />
          <RightCol saleTransfer={saleTransfer} />
        </Row>
        <Row>
          <Col className={styles.progress}>
            <CompleteProgress {...acquisitionTransfer.dataCompleteness} />
          </Col>
        </Row>
      </div>
    )
  }
}
