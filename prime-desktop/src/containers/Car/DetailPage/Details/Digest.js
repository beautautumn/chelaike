import React from 'react'
import { price, licensedInfoText, displacement, computeWarningLevel } from 'helpers/car'
import date from 'helpers/date'
import { unit } from 'helpers/app'
import { StockAge, Gallery, Segment } from 'components'
import cx from 'classnames'
import compact from 'lodash/compact'
import styles from '../DetailPage.scss'
import can from 'helpers/can'

export default ({ car, transfersById, shopsById, usersById }) => {
  let acquisitionTransfer
  if (transfersById) {
    acquisitionTransfer = transfersById[car.acquisitionTransfer]
  }

  const warningClassName = computeWarningLevel(car)
  const title = (
    <h1 className={cx('ui header', warningClassName)}>
      {car.systemName}
      {warningClassName &&
        <label className={cx('ui', warningClassName, 'label')}>
          {warningClassName === 'yellow' && '黄色预警'}
          {warningClassName === 'red' && '红色预警'}
        </label>
      }
    </h1>
  )

  return (
    <Segment className={cx('ui grid segment', styles.digest)}>
      {car.reserved && (
        <span className="ui green top left attached label">
          已预定
        </span>
      )}
      <div className="eight wide column">
        <Gallery images={car.images} defaultImage="car" />
      </div>
      <div className="eight wide column">
        <div className="content">
          {title}
          <div className="meta">
            <div className="ui four cards">
              <div className="red card">
                <div className="content">
                  <div className="header">新车完税价</div>
                  <div className="value">
                    {price(car.newCarFinalPriceWan, '万')}
                  </div>
                </div>
              </div>
              <div className="red card">
                <div className="content">
                  <div className="header">销售价</div>
                  <div className="value">
                    {price(car.showPriceWan, '万')}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="description">
            <table className="ui left aligned celled table">
              <tbody>
                <tr>
                  <td className="header">所属分店</td>
                  <td>{shopsById[car.shop].name}</td>
                  <td className="header">库存号</td>
                  <td>{car.stockNumber}</td>
                </tr>
                {can('收购信息查看') &&
                  <tr>
                    <td className="header">收购员</td>
                    <td>{usersById[car.acquirer].name}</td>
                    <td className="header">收购日期</td>
                    <td>{date(car.acquiredAt)}</td>
                  </tr>
                }
                <tr>
                  <td className="header">车架号</td>
                  <td>{car.vin}</td>
                  <td className="header">车牌号</td>
                  <td>{acquisitionTransfer && acquisitionTransfer.currentPlateNumber}</td>
                </tr>
                <tr>
                  <td className="header">上牌日期</td>
                  <td>{licensedInfoText(car)}</td>
                  <td className="header">排量</td>
                  <td>{displacement(car)}</td>
                </tr>
                <tr>
                  <td className="header">表显/实际里程</td>
                  <td>
                    {
                      compact([
                        unit(car.mileage, '万公里'),
                        unit(car.mileageInFact, '万公里')
                      ]).join('/')
                    }
                  </td>
                  <td className="header">外观/内饰</td>
                  <td>
                    {car.exteriorColor || '暂无'}/{car.interiorColor || '暂无'}
                  </td>
                </tr>
              </tbody>
            </table>
            {can('车辆库龄查看') && <StockAge car={car} />}
          </div>
        </div>
      </div>
    </Segment>
  )
}
