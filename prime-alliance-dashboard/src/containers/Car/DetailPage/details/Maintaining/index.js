import React, { PropTypes } from 'react'
import { Element } from 'react-scroll'
import { unit } from 'helpers/app'
import { Segment } from 'components'
import styles from '../../style.scss'

export default function Maitaining({ car, enumValues }) {
  return (
    <Element name="maitaining">
      <Segment>
        <div>保养信息</div>
        <table className={styles.table}>
          <tbody>
            <tr>
              <td className={styles.header}>保养里程</td>
              <td>{unit(car.maintainMileage, '万公里')}</td>
            </tr>
            <tr>
              <td className={styles.header}>保养记录</td>
              <td>{car.hasMaintainHistory ? '有' : '无'}</td>
            </tr>
            <tr>
              <td className={styles.header}>新车质保</td>
              <td>{enumValues.car.new_car_warranty[car.newCarWarranty]}</td>
            </tr>
          </tbody>
        </table>
      </Segment>
    </Element>
  )
}

Maitaining.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}
