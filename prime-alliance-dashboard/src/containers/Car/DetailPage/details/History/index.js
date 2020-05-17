import React, { Component, PropTypes } from 'react'
import date from 'helpers/date'
import { price } from 'helpers/car'
import { Element } from 'react-scroll'
import { Timeline } from 'antd'
import { Segment } from 'components'
import styles from '../../style.scss'

export default class History extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    enumValues: PropTypes.object,
  }

  priceInfo(messages) {
    const priceNames = {
      showPriceWan: '展厅价',
      onlinePriceWan: '网络价',
      salesMinimunPriceWan: '销售底价',
      managerPriceWan: '经理底价',
      allianceMinimunPriceWan: '联盟底价',
    }
    const changedPrices = []

    Object.keys(priceNames).forEach((key) => {
      const prevKey = `previous${key[0].toUpperCase()}${key.slice(1)}`
      if (messages[key] !== messages[prevKey]) {
        changedPrices.push({
          name: priceNames[key],
          info: `从 ${price(messages[prevKey], '万')} 调整为 ${price(messages[key], '万')}`,
        })
      }
    })

    if (changedPrices.length <= 3) {
      return changedPrices.map(item => `${item.name} ${item.info}`)
    }

    const result = changedPrices.map(item => item.name).join(' ')
    return `对 ${result} 做了修改`
  }

  renderRecords() {
    const { car: { operationRecords }, enumValues: { car: { state } } } = this.props
    return operationRecords.map((record, index) => {
      const { messages } = record
      let color
      let content = []
      switch (record.operationRecordType) {
        case 'car_created':
          color = 'green'
          content = [
            `${messages.userName} 完成车辆入库`,
          ]
          break
        case 'state_changed':
          color = 'blue'
          content = [
            `${messages.userName} 更新车辆状态`,
            `${state[messages.previousState]} 调整为 ${state[messages.currentState]}`,
          ]
          break
        case 'car_priced':
          color = 'red'
          content = [
            `${messages.userName} 调整车辆定价`,
            this.priceInfo(messages),
          ]
          break
        case 'car_reserved':
          color = 'blue'
          content = [
            `${messages.userName} 完成车辆预定`,
          ]
          break
        case 'car_updated':
          color = 'blue'
          content = [
            `${messages.userName} 更新车辆资料`,
          ]
          break
        case 'stock_back':
          color = 'blue'
          content = [
            `${messages.name} 回库`,
          ]
          break
        case 'stock_out':
          color = 'blue'
          if (messages.stockOutType === 'driven_back') {
            content = [
              `${messages.userName} 完成车辆车主开回`,
            ]
          } else if (messages.stockOutType === 'sold') {
            content = [
              `${messages.userName} 完成车辆销售出库`,
            ]
          } else if (messages.stockOutType === 'acquisition_refunded') {
            content = [
              `${messages.userName} 完成车辆收购退车`,
            ]
          }
          break
        default:
          color = 'red'
      }
      return (
        <Timeline.Item key={index} color={color} className={styles.timeline}>
          <h5 className={styles.timelineHeader}>{record.messages.title}</h5>
          {date(record.createdAt, 'full')}
          {content.map((line, index) => (
            <p key={index} className={styles.timelineInfo}>{line}</p>
          ))}
        </Timeline.Item>
      )
    })
  }

  render() {
    return (
      <Element name="history">
        <Segment>
          <h3>操作历史</h3>
          <Timeline>
            {this.renderRecords()}
          </Timeline>
        </Segment>
      </Element>
    )
  }
}
