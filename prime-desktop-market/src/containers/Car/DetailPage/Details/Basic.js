import React from 'react'
import date from 'helpers/date'
import nl2br from 'react-nl2br'
import { displacement } from 'helpers/car'
import { unit } from 'helpers/app'
import compact from 'lodash/compact'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import can from 'helpers/can'

export default ({ car, enumValues, transfersById }) => {
  let acquisitionTransfer
  if (transfersById) {
    acquisitionTransfer = transfersById[car.acquisitionTransfer]
  }

  return (
    <Element name="basic">
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3 className="ui dividing header">基本信息</h3>
          <table className="ui left aligned celled table">
            <tbody>
              {car.systemName !== car.name && <tr>
                <td className="two wide header">宣传标题</td>
                <td className="six wide">{car.name}</td>
              </tr>}
              <tr>
                <td className="two wide header">库存编号</td>
                <td className="six wide">{car.stockNumber}</td>
                <td className="two wide header">收购日期</td>
                <td className="six wide">{date(car.acquiredAt)}</td>
              </tr>
              <tr>
                <td className="header">车辆状态</td>
                <td>
                  {car.stateText}
                  {car.stateNote && <span>({car.stateNote})</span>}
                </td>
                <td className="header">外观/内饰</td>
                <td>
                  {car.exteriorColor || '暂无'}/{car.interiorColor || '暂无'}
                </td>
              </tr>
              {can('收购信息查看') &&
                <tr>
                  <td className="header">收购类型</td>
                  <td>{enumValues.car.acquisition_type[car.acquisitionType]}</td>
                  <td className="header">收购渠道</td>
                  <td>{car.channel && car.channel.name}</td>
                </tr>
              }
              <tr>
                <td className="header">车架号</td>
                <td>{car.vin}</td>
                <td className="header">出厂年月</td>
                <td>{date(car.manufacturedAt)}</td>
              </tr>
              <tr>
                <td className="header">品牌车型</td>
                <td>{car.name}</td>
                <td className="header">表显/实际里程</td>
                <td>
                  {
                    compact([
                      unit(car.mileage, '万公里'),
                      unit(car.mileageInFact, '万公里')
                    ]).join('/')
                  }
                </td>
              </tr>
              <tr>
                <td className="header">排气量</td>
                <td>{displacement(car)}</td>
                <td className="header">环保标准</td>
                <td>{enumValues.car.emission_standard[car.emissionStandard]}</td>
              </tr>
              <tr>
                <td className="header">交强险到期</td>
                <td>{acquisitionTransfer && date(acquisitionTransfer.compulsoryInsuranceEndAt)}</td>
                <td className="header">年审到期</td>
                <td>{acquisitionTransfer && date(acquisitionTransfer.annualInspectionEndAt)}</td>
              </tr>
              <tr>
                <td className="header">商业险到期</td>
                <td>{acquisitionTransfer && date(acquisitionTransfer.commercialInsuranceEndAt)}</td>
                <td className="header">商业险金额</td>
                <td>{acquisitionTransfer && acquisitionTransfer.commercialInsuranceAmountYuan}</td>
              </tr>
              <tr>
                <td className="header">变速箱</td>
                <td>{enumValues.car.transmission[car.transmission]}</td>
                <td className="header">车身类型</td>
                <td>{enumValues.car.car_type[car.carType]}</td>
              </tr>
              <tr>
                <td className="header">车辆等级</td>
                <td>{car.level}</td>
                <td className="header">状态备注</td>
                <td>{car.satetNote}</td>
              </tr>
              <tr>
                <td className="header">车辆附件</td>
                <td colSpan="3">
                  {car.attachments &&
                    car.attachments.reduce(
                      (pre, cur) => `${pre}${pre ? '，' : ''}${enumValues.car.attachments[cur]}`, '')
                  }
                </td>
              </tr>
              <tr>
                <td className="header">费用情况</td>
                <td colSpan="3">
                  {nl2br(car.feeDetail)}
                </td>
              </tr>
              <tr>
                <td className="header">瑕疵描述</td>
                <td colSpan="3">
                  {nl2br(car.interiorNote)}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </Segment>
    </Element>
  )
}
