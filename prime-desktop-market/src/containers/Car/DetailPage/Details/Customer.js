import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import date from 'helpers/date'
import { price } from 'helpers/car'
import get from 'lodash/get'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import can from 'helpers/can'

export default class Customer extends PureComponent {
  static propTypes = {
    car: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    stockOutInventory: PropTypes.object.isRequired
  }

  renderReserverCustomer() {
    const { car } = this.props

    return (
      <div className="eight wide column">
        <table className="ui left aligned celled table">
          <tbody>
            <tr>
              <td className="four wide header">预定状态</td>
              <td className="four wide">已预定</td>
              <td className="four wide header">预定日期</td>
              <td className="four wide">{date(get(car, 'carReservation.reservedAt'))}</td>
            </tr>
            <tr>
              <td className="header">销售员</td>
              <td colSpan="3">{get(car, 'carReservation.seller.name')}</td>
            </tr>
            <tr>
              <td className="header">客户名称</td>
              <td>{get(car, 'carReservation.customerName')}</td>
              <td className="header">联系电话</td>
              <td>{get(car, 'carReservation.customerPhone')}</td>
            </tr>
            <tr>
              <td className="header">定金</td>
              <td>
                {price(get(car, 'carReservation.depositWan'), '万')}
              </td>
              <td className="header">成交价格</td>
              <td>
                {price(get(car, 'carReservation.closingCostWan'), '万')}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    )
  }

  render() {
    const { car, enumValues, stockOutInventory } = this.props

    return (
      <Element name="customer">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h3 className="ui dividing header">客户信息</h3>
            <div className="ui grid">
              {car.reserved && this.renderReserverCustomer()}
              {can('销售成交信息查看') &&
                <div className="eight wide column">
                  <table className="ui left aligned celled table">
                    <tbody>
                      <tr>
                        <td className="four wide header">成交状态</td>
                        <td className="four wide">{car.state === 'sold' ? '已成交' : '未成交'}</td>
                        <td className="four wide header">成交日期</td>
                        <td className="four wide">{date(get(stockOutInventory, 'completedAt'))}</td>
                      </tr>
                      <tr>
                        <td className="four wide header">销售员</td>
                        <td>{get(stockOutInventory, 'seller.name')}</td>
                        <td className="header">成交分成</td>
                        <td>{price(get(stockOutInventory, 'carriedInterestWan'), '万')}</td>
                      </tr>
                      <tr>
                        <td className="four wide header">客户名称</td>
                        <td className="four wide">{get(stockOutInventory, 'customerName')}</td>
                        <td className="four wide header">联系电话</td>
                        <td className="four wide">{get(stockOutInventory, 'customerPhone')}</td>
                      </tr>
                      <tr>
                        <td className="header">成交价格</td>
                        <td>{price(get(stockOutInventory, 'closingCostWan'), '万')}</td>
                        <td className="header">付款方式</td>
                        {/*eslint-disable*/}
                        <td>{enumValues.stock_out_inventory.payment_type[get(stockOutInventory, 'paymentType')]}</td>
                        {/*eslint-enable*/}
                      </tr>
                      <tr>
                        <td className="header">定金</td>
                        <td>{price(get(stockOutInventory, 'depositWan'), '万')}</td>
                        <td className="header">余额</td>
                        <td>{price(get(stockOutInventory, 'remainingMoneyWan'), '万')}</td>
                      </tr>
                      <tr>
                        <td className="header">贷款公司</td>
                        <td>{get(stockOutInventory, 'mortgageCompany.name')}</td>
                        <td className="header">贷款额度</td>
                        <td>{get(stockOutInventory, 'loanAmountWan')}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              }
            </div>
          </div>
        </Segment>
      </Element>
    )
  }
}
