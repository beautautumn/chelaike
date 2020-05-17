import React from 'react'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import can from 'helpers/can'

export default ({ car, stockOutInventory }) => (
  <Element name="mortgage">
    <Segment className="ui grid segment">
      <div className="sixteen wide column">
        <h3 className="ui dividing header">按揭信息</h3>
        <table className="ui left aligned celled table">
          {stockOutInventory &&
           stockOutInventory.mortgageCompany &&
           can('按揭信息查看', null, car.shop) &&
            <tbody>
              <tr>
                <td className="two wide header">按揭公司</td>
                <td colSpan="3">{stockOutInventory.mortgageCompany.name}</td>
              </tr>
              <tr>
                <td className="two wide header">首付款</td>
                <td className="six wide">
                  {stockOutInventory.downPaymentWan}
                </td>
                <td className="two wide header">按揭周期</td>
                <td className="six wide">
                  {stockOutInventory.mortgagePeriodMonths}
                </td>
              </tr>
              <tr>
                <td className="two wide header">按揭费用</td>
                <td className="six wide">
                  {stockOutInventory.mortgageFeeYuan}
                </td>
                <td className="two wide header">贷款额度</td>
                <td className="six wide">
                  {stockOutInventory.loanAmountWan}
                </td>
              </tr>
            </tbody>
          }
        </table>
      </div>
    </Segment>
  </Element>
)
