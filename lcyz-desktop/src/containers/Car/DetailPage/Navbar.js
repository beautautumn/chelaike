import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Affix } from 'antd'
import { Link } from 'react-scroll'
import cx from 'classnames'
import can from 'helpers/can'
import { Segment } from 'components'
import styles from './DetailPage.scss'

const items = [
  { name: 'basic', text: '基本信息' },
  { name: 'cost', text: '成本信息', crossShop: true, authority: '收购价格查看' },
  { name: 'sales', text: '销售信息' },
  { name: 'customer', text: '客户信息', crossShop: true },
  { name: 'maintenanceRecord', text: '维保纪录', crossShop: true, authority: '维保详情查看' },
  { name: 'mortgage', text: '按揭信息', crossShop: true },
  { name: 'insurance', text: '保险信息', crossShop: true },
  { name: 'maitaining', text: '保养信息' },
  { name: 'features', text: '车辆配置' },
  { name: 'licenses', text: '牌证信息', crossShop: true },
  { name: 'history', text: '操作历史', crossShop: true }
]

export default class Navbar extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired
  }

  renderItems() {
    const { car } = this.props
    const enabledItem = items.filter(item => !item.crossShop || can(item.authority, null, car.shop))

    const widthRatio = `${(100 / enabledItem.length).toFixed(3)}%`

    return enabledItem.reduce((accumulator, item) => {
      accumulator.push(
        <Link
          key={item.name}
          className="item"
          style={{ width: widthRatio }}
          to={item.name}
          smooth
          offset={-100}
          duration={500}
        >
          {item.text}
        </Link>
      )
      return accumulator
    }, [])
  }

  render() {
    const renderedItems = this.renderItems()

    return (
      <Affix>
        <Segment className={cx('ui item tabs menu', styles.navbar)}>
          {renderedItems}
        </Segment>
      </Affix>
    )
  }
}
