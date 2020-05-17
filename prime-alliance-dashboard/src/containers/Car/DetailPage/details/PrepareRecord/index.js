import React, { Component, PropTypes } from 'react'
import date from 'helpers/date'
import get from 'lodash/get'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import styles from '../../style.scss'

export default class PrepareRecord extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    prepareRecordsById: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
  }

  renderPrepareItems(items = []) {
    return items.reduce((accumulator, item) => {
      let note
      if (item.note) {
        note = <span>(备注：{item.note})</span>
      }
      accumulator.push(
        <tr>
          <td className={styles.header}>整备项目</td>
          <td colSpan="3">
            {item.name}： {item.amountYuan} 元 {note}
          </td>
        </tr>
      )
      return accumulator
    }, [])
  }

  render() {
    const { car, prepareRecordsById, enumValues } = this.props
    if (!prepareRecordsById) {
      return (
        <Element name="prepareRecord">
          <Segment>
            <h3>整备信息</h3>
          </Segment>
        </Element>
      )
    }
    const prepareRecord = prepareRecordsById[car.prepareRecord]
    return (
      <Element name="prepareRecord">
        <Segment>
          <h3>整备信息</h3>
          <table className={styles.table}>
            <tbody>
              <tr>
                <td className={styles.header}>整备状态</td>
                <td>
                  {enumValues.prepare_record.state[prepareRecord.state]}
                </td>
                <td className={styles.header}>开始结束时间</td>
                <td>
                  {date(prepareRecord.startAt)} ～ {date(prepareRecord.endAt)}
                </td>
              </tr>
              {this.renderPrepareItems(prepareRecord.prepareItems)}
              <tr>
                <td className={styles.header}>费用总计</td>
                <td>{prepareRecord.totalAmountYuan}元</td>
                <td className={styles.header}>整备员</td>
                <td>{get(prepareRecord, 'preparer.name')}</td>
              </tr>
            </tbody>
          </table>
        </Segment>
      </Element>
    )
  }
}
