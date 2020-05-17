import React, { PropTypes } from 'react'
import { Row, Col } from 'antd'
import date from 'helpers/date'
import nl2br from 'react-nl2br'
import { displacement } from 'helpers/car'
import { unit } from 'helpers/app'
import compact from 'lodash/compact'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import can from 'helpers/can'
import styles from '../../style.scss'

export default function Basic({ car, enumValues }) {
  const acquisitionTransfer = car.acquisitionTransfer

  return (
    <Element name="basic">
      <Segment>
        <Row>
          <Col>
            <h3>基本信息</h3>
            <table className={styles.table}>
              <tbody>
                {car.systemName !== car.name &&
                  <tr>
                    <td className={styles.header}>宣传标题</td>
                    <td>{car.name}</td>
                  </tr>
                }
                <tr>
                  <td className={styles.header}>库存编号</td>
                  <td>{car.stockNumber}</td>
                  <td className={styles.header}>收购日期</td>
                  <td>{date(car.acquiredAt)}</td>
                </tr>
                <tr>
                  <td className={styles.header}>车辆状态</td>
                  <td>
                    {car.stateText}
                    {car.stateNote && <span>({car.stateNote})</span>}
                  </td>
                  <td className={styles.header}>外观/内饰</td>
                  <td>
                    {car.exteriorColor || '暂无'}/{car.interiorColor || '暂无'}
                  </td>
                </tr>
                {can('收购信息查看') &&
                  <tr>
                    <td className={styles.header}>收购类型</td>
                    <td>{enumValues.car.acquisition_type[car.acquisitionType]}</td>
                    <td className={styles.header}>收购渠道</td>
                    <td>{car.channel && car.channel.name}</td>
                  </tr>
                }
                <tr>
                  <td className={styles.header}>车架号</td>
                  <td>{car.vin}</td>
                  <td className={styles.header}>出厂日期</td>
                  <td>{date(car.manufacturedAt)}</td>
                </tr>
                <tr>
                  <td className={styles.header}>品牌车型</td>
                  <td>{car.name}</td>
                  <td className={styles.header}>表显/实际里程</td>
                  <td>
                    {
                      compact([
                        unit(car.mileage, '万公里'),
                        unit(car.mileageInFact, '万公里'),
                      ]).join('/')
                    }
                  </td>
                </tr>
                <tr>
                  <td className={styles.header}>排气量</td>
                  <td>{displacement(car)}</td>
                  <td className={styles.header}>环保标准</td>
                  <td>{enumValues.car.emission_standard[car.emissionStandard]}</td>
                </tr>
                <tr>
                  <td className={styles.header}>交强险到期</td>
                  <td>
                    {acquisitionTransfer && date(acquisitionTransfer.compulsoryInsuranceEndAt)}
                  </td>
                  <td className={styles.header}>年审到期</td>
                  <td>
                    {acquisitionTransfer && date(acquisitionTransfer.annualInspectionEndAt)}
                  </td>
                </tr>
                <tr>
                  <td className={styles.header}>商业险到期</td>
                  <td>
                    {acquisitionTransfer && date(acquisitionTransfer.commercialInsuranceEndAt)}
                  </td>
                  <td className={styles.header}>商业险金额</td>
                  <td>
                    {acquisitionTransfer && acquisitionTransfer.commercialInsuranceAmountYuan}
                  </td>
                </tr>
                <tr>
                  <td className={styles.header}>变速箱</td>
                  <td>{enumValues.car.transmission[car.transmission]}</td>
                  <td className={styles.header}>车身类型</td>
                  <td>{enumValues.car.car_type[car.carType]}</td>
                </tr>
                <tr>
                  <td className={styles.header}>车辆等级</td>
                  <td>{car.level}</td>
                  <td className={styles.header}>状态备注</td>
                  <td>{car.satetNote}</td>
                </tr>
                <tr>
                  <td className={styles.header}>瑕疵描述</td>
                  <td colSpan="3">
                    {nl2br(car.interiorNote)}
                  </td>
                </tr>
              </tbody>
            </table>
          </Col>
        </Row>
      </Segment>
    </Element>
  )
}

Basic.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}
