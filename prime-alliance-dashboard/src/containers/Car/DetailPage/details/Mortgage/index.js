import React, { PropTypes } from 'react'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import can from 'helpers/can'
import styles from '../../style.scss'

export default function Mortgage({ car, stockOutInventory }) {
  return (
    <Element name="mortgage">
      <Segment className="ui grid segment">
        <h3>按揭信息</h3>
        <table className={styles.table}>
          {stockOutInventory &&
           stockOutInventory.mortgageCompany &&
           can('按揭信息查看', null, car.shop) &&
            <tbody>
              <tr>
                <td className={styles.header}>按揭公司</td>
                <td colSpan="3">{stockOutInventory.mortgageCompany.name}</td>
              </tr>
              <tr>
                <td className={styles.header}>首付款</td>
                <td>
                  {stockOutInventory.downPaymentWan}
                </td>
                <td className={styles.header}>按揭周期</td>
                <td>
                  {stockOutInventory.mortgagePeriodMonths}
                </td>
              </tr>
              <tr>
                <td className={styles.header}>按揭费用</td>
                <td>
                  {stockOutInventory.mortgageFeeYuan}
                </td>
                <td className={styles.header}>贷款额度</td>
                <td>
                  {stockOutInventory.loanAmountWan}
                </td>
              </tr>
            </tbody>
          }
        </table>
      </Segment>
    </Element>
  )
}

Mortgage.propTypes = {
  car: PropTypes.object.isRequired,
  stockOutInventory: PropTypes.object.isRequired,
}
