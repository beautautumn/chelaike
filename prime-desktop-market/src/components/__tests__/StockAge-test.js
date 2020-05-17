import expect from 'expect'
import React from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import StockAge from '../StockAge/StockAge'
import styles from '../StockAge/StockAge.scss'

describe('StockAge', () => {
  it('render yellow stock age', () => {
    const car = {
      stockAgeDays: 10,
      yellowStockWarningDays: 30,
      redStockWarningDays: 45
    }
    const stockAge = renderToStaticMarkup(<StockAge car={car} />)
    const expectedOutput =
      `<span><span class="">10</span> / <span class="${styles.yellow}">30</span></span>`

    expect(stockAge).toEqual(expectedOutput)
  })

  it('render yellow/red stock age', () => {
    const car = {
      stockAgeDays: 31,
      yellowStockWarningDays: 30,
      redStockWarningDays: 45
    }
    const stockAge = renderToStaticMarkup(<StockAge car={car} />)
    /*eslint-disable*/
    const expectedOutput =
      `<span><span class="${styles.yellow}">31</span> / <span class="${styles.red}">45</span></span>`
    /*eslint-enable*/

    expect(stockAge).toEqual(expectedOutput)
  })

  it('render red stock age', () => {
    const car = {
      stockAgeDays: 46,
      yellowStockWarningDays: 30,
      redStockWarningDays: 45
    }
    const stockAge = renderToStaticMarkup(<StockAge car={car} />)
    const expectedOutput =
      `<span><span class="${styles.red}">46</span> / <span class="${styles.red}">45</span></span>`

    expect(stockAge).toEqual(expectedOutput)
  })
})
