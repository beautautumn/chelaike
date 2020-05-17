import React, { PropTypes } from 'react'
import styles from './style.scss'

export default function StockAge({ car, enumValues }) {
  let stockDaysClass = ''
  let warndaysClass = styles.yellow
  let warnDays = car.yellowStockWarningDays

  if (car.stockAgeDays >= car.yellowStockWarningDays &&
      car.stockAgeDays < car.redStockWarningDays) {
    stockDaysClass = styles.yellow
    warndaysClass = styles.red
    warnDays = car.redStockWarningDays
  } else if (car.stockAgeDays >= car.redStockWarningDays) {
    stockDaysClass = styles.red
    warndaysClass = styles.red
    warnDays = car.redStockWarningDays
  }

  return (
    <div>
      <span className={stockDaysClass}>
        {car.stockAgeDays}
      </span> /
      <span className={warndaysClass}>
        {warnDays}
      </span>
      {enumValues &&
        <div>
          {enumValues.car.state[car.state]}
          <br />
          {car.stateNote && <span>({car.stateNote})</span>}
        </div>
      }
    </div>
  )
}

StockAge.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object,
}
