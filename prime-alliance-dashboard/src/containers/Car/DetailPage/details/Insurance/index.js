import React, { PropTypes } from 'react'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import styles from '../../style.scss'

export default function Insurance({ stockOutInventory }) {
  return (
    <Element name="insurance">
      <Segment>
        <h3>保险信息</h3>
        <table className={styles.table}>
          {stockOutInventory && stockOutInventory.insuranceCompany &&
            <tbody>
              <tr>
                <td className={styles.header}>保险公司</td>
                <td colSpan="3">{stockOutInventory.insuranceCompany.name}</td>
              </tr>
              <tr>
                <td className={styles.header}>商业险</td>
                <td>
                  {stockOutInventory.commercialInsuranceFeeYuan}
                </td>
                <td className={styles.header}>交强险</td>
                <td>
                  {stockOutInventory.compulsoryInsuranceFeeYuan}
                </td>
              </tr>
              <tr>
                <td className={styles.header}>备注</td>
                <td colSpan="3">
                  {stockOutInventory.note}
                </td>
              </tr>
            </tbody>
          }
        </table>
      </Segment>
    </Element>
  )
}

Insurance.propTypes = {
  stockOutInventory: PropTypes.object.isRequired,
}
