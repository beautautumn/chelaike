import React, { PropTypes } from 'react'
import { Card, Row, Col } from 'antd'
import { Gallery, Segment } from 'components'
import { StockAge } from 'containers/Car/components'
import { price, licensedInfoText, displacement, computeWarningLevel } from 'helpers/car'
import date from 'helpers/date'
import { unit } from 'helpers/app'
import can from 'helpers/can'
import cx from 'classnames'
import compact from 'lodash/compact'
import styles from '../../style.scss'

export default function Digest({ car }) {
  const acquisitionTransfer = car.acquisitionTransfer

  const warningClassName = computeWarningLevel(car)
  const title = (
    <h1 className={warningClassName}>
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
    <Segment classnames={styles.digest}>
      {car.reserved && (
        <span className="ui green top right attached label">
          已预定
        </span>
      )}
      <Row>
        <Col span="12">
          <Gallery images={car.images} defaultImage="car" />
        </Col>
        <Col span="11" offset="1">
          <div className="content">
            {title}
            <div className="meta">
              <Row>
                <Col span="6">
                  <Card title="新车完税价">
                    {price(car.newCarFinalPriceWan, '万')}
                  </Card>
                </Col>
                <Col span="6" offset="1">
                  <Card title="销售价">
                    {price(car.showPriceWan, '万')}
                  </Card>
                </Col>
              </Row>
            </div>
            <div className="description">
              <table className={styles.table}>
                <tbody>
                  <tr>
                    <td className={styles.header}>所属车商</td>
                    <td>{car.company.nickname}</td>
                    <td className={styles.header}>库存号</td>
                    <td>{car.stockNumber}</td>
                  </tr>
                  {can('收购信息查看') &&
                    <tr>
                      <td className={styles.header}>收购员</td>
                      <td>{car.acquirer.name}</td>
                      <td className={styles.header}>收购日期</td>
                      <td>{date(car.acquiredAt)}</td>
                    </tr>
                  }
                  <tr>
                    <td className={styles.header}>车架号</td>
                    <td>{car.vin}</td>
                    <td className={styles.header}>车牌号</td>
                    <td>{acquisitionTransfer && acquisitionTransfer.currentPlateNumber}</td>
                  </tr>
                  <tr>
                    <td className={styles.header}>上牌日期</td>
                    <td>{licensedInfoText(car)}</td>
                    <td className={styles.header}>排量</td>
                    <td>{displacement(car)}</td>
                  </tr>
                  <tr>
                    <td className={styles.header}>表显/实际里程</td>
                    <td>
                      {
                        compact([
                          unit(car.mileage, '万公里'),
                          unit(car.mileageInFact, '万公里'),
                        ]).join('/')
                      }
                    </td>
                    <td className={styles.header}>外观/内饰</td>
                    <td>
                      {car.exteriorColor || '暂无'}/{car.interiorColor || '暂无'}
                    </td>
                  </tr>
                </tbody>
              </table>
              {can('车辆库龄查看') && <StockAge car={car} />}
            </div>
          </div>
        </Col>
      </Row>
    </Segment>
  )
}

Digest.propTypes = {
  car: PropTypes.object.isRequired,
}
