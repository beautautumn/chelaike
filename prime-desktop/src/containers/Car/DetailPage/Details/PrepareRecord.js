import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import date from 'helpers/date'
import get from 'lodash/get'
import { Element } from 'react-scroll'
import { Segment } from 'components'

export default class PrepareRecord extends PureComponent {
  static propTypes = {
    car: PropTypes.object.isRequired,
    prepareRecordsById: PropTypes.object,
    enumValues: PropTypes.object.isRequired
  }

  renderPrepareItems(items = []) {
    return items.reduce((accumulator, item, index) => {
      let note
      if (item.note) {
        note = <span>(备注：{item.note})</span>
      }
      accumulator.push(
        <tr key={index}>
          <td className="header">整备项目</td>
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
          <Segment className="ui grid segment">
            <div className="sixteen wide column">
              <h3 className="ui dividing header">整备信息</h3>
            </div>
          </Segment>
        </Element>
      )
    }
    const prepareRecord = prepareRecordsById[car.prepareRecord]
    return (
      <Element name="prepareRecord">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h3 className="ui dividing header">整备信息</h3>
            <table className="ui left aligned celled table">
              <tbody>
                <tr>
                  <td className="two wide header">整备状态</td>
                  <td className="six wide">
                    {enumValues.prepare_record.state[prepareRecord.state]}
                  </td>
                  <td className="two wide header">开始结束时间</td>
                  <td className="six wide">
                    {date(prepareRecord.startAt)} ～ {date(prepareRecord.endAt)}
                  </td>
                </tr>
                {this.renderPrepareItems(prepareRecord.prepareItems)}
                <tr>
                  <td className="header">费用总计</td>
                  <td>{prepareRecord.totalAmountYuan}元</td>
                  <td className="header">整备员</td>
                  <td>{get(prepareRecord, 'preparer.name')}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </Segment>
      </Element>
    )
  }
}
