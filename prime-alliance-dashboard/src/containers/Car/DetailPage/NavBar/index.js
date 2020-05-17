import React, { Component, PropTypes } from 'react'
import { Affix } from 'antd'
import { Link } from 'react-scroll'
import can from 'helpers/can'
import styles from './style.scss'

const items = [
  { name: 'basic', text: '基本信息' },
  { name: 'sales', text: '销售信息' },
  { name: 'customer', text: '交易信息' },
  { name: 'mortgage', text: '按揭信息' },
  { name: 'insurance', text: '保险信息' },
  { name: 'maitaining', text: '保养信息' },
  { name: 'features', text: '车辆配置' },
  { name: 'prepareRecord', text: '整备信息' },
  { name: 'licenses', text: '牌证信息' },
  { name: 'history', text: '操作历史' },
]

export default class Navbar extends Component {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
  }

  renderItems() {
    const { car } = this.props
    return items.reduce((accumulator, item) => {
      if (can(null, null, car.shop)) {
        accumulator.push(
          <Link
            key={item.name}
            className={styles.item}
            to={item.name}
            smooth
            offset={-100}
            duration={500}
          >
            {item.text}
          </Link>
        )
      }
      return accumulator
    }, [])
  }

  render() {
    const renderedItems = this.renderItems()

    return (
      <Affix>
        <div className={styles.navbar}>
          {renderedItems}
        </div>
      </Affix>
    )
  }
}
