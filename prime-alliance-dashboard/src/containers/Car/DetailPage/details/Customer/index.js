import React, { PropTypes } from 'react'
import { Row, Col } from 'antd'
import date from 'helpers/date'
import { price } from 'helpers/car'
import get from 'lodash/get'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import styles from '../../style.scss'

export default function Customer({ car, enumValues, stockOutInventory }) {
  return (
    <Element name="customer">
      <Segment className="ui grid segment">
        <h3>客户信息</h3>
        <Row>
          {car.reserved && (
            <Col span={12}>
              <table className={styles.table}>
                <tbody>
                  <tr>
                    <td className={styles.header}>预定状态</td>
                    <td>已预定</td>
                    <td className={styles.header}>预定日期</td>
                    <td>{date(get(car, 'carReservation.reservedAt'))}</td>
                  </tr>
                  <tr>
                    <td className={styles.header}>销售员</td>
                    <td>{get(car, 'carReservation.seller.name')}</td>
                  </tr>
                </tbody>
              </table>
            </Col>
          )}
          <Col span="12">
            <table className={styles.table}>
              <tbody>
                <tr>
                  <td className={styles.header}>成交状态</td>
                  <td>{car.state === 'sold' ? '已成交' : '未成交'}</td>
                  <td className={styles.header}>成交日期</td>
                  <td>{date(get(stockOutInventory, 'completedAt'))}</td>
                </tr>
                <tr>
                  <td className={styles.header}>销售员</td>
                  <td>{get(stockOutInventory, 'seller.name')}</td>
                  <td className={styles.header}>成交分成</td>
                  <td>{price(get(stockOutInventory, 'carriedInterestWan'), '万')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>成交价格</td>
                  <td>{price(get(stockOutInventory, 'closingCostWan'), '万')}</td>
                  <td className={styles.header}>付款方式</td>
                  {/*eslint-disable*/}
                  <td>{enumValues.stock_out_inventory.payment_type[get(stockOutInventory, 'paymentType')]}</td>
                  {/*eslint-enable*/}
                </tr>
                <tr>
                  <td className={styles.header}>贷款公司</td>
                  <td>{get(stockOutInventory, 'mortgageCompany.name')}</td>
                  <td className={styles.header}>贷款额度</td>
                  <td>{get(stockOutInventory, 'loanAmountWan')}</td>
                </tr>
              </tbody>
            </table>
          </Col>
        </Row>
      </Segment>
    </Element>
  )
}

Customer.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
  stockOutInventory: PropTypes.object.isRequired,
}
