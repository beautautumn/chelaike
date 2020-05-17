import React from 'react'
import styles from './StockAge.scss'

export default ({ car }) => {
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
    <span>
      <span className={stockDaysClass}>
        {car.stockAgeDays}
      </span> / <span className={warndaysClass}>
        {warnDays}
      </span>
    </span>
  )
}
