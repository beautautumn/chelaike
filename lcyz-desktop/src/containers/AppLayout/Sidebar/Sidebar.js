import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Link } from 'react-router'
import styles from './Sidebar.scss'
import cx from 'classnames'
import { Logo } from 'components'
import { scale } from 'helpers/image'
import can from 'helpers/can'

const items = [
  {
    name: '车辆管理',
    children: [
      { name: '在库车辆', link: '/cars', icon: 'car', authority: '在库车辆查询' },
      { name: '出库车辆', link: '/stock_out_cars', icon: 'taxi', authority: '已出库车辆查询' },
      { name: '牌证管理', link: '/licenses', icon: 'payment', authority: '牌证信息查看' },
      { name: '整备管理', link: '/prepare_records', icon: 'legal', authority: '整备信息查看' }
    ]
  },
  {
    name: '客户管理',
    children: [
      { name: '客户跟踪', link: '/intentions/following', icon: 'sitemap' },
      { name: '坐席录入', link: '/intentions/service', icon: 'travel', authority: '坐席录入' },
      { name: '服务预约', link: '/service_appointments', icon: 'phone' }
    ],
  },
  {
    name: '系统配置',
    children: [
      { name: '公司信息', link: '/company', icon: 'newspaper', authority: '公司信息设置' },
      { name: '角色管理', link: '/roles', icon: 'user', authority: '角色管理' },
      { name: '员工管理', link: '/users', icon: 'users', authority: '员工管理' },
      { name: '业务设置', link: '/setting/shops', icon: 'setting', authority: '业务设置' },
      { name: '导入记录', link: '/import_tasks', icon: 'cube' }
    ]
  }
]

export default class Sidebar extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    handleLogout: PropTypes.func.isRequired
  }

  renderLinkItems(items) {
    const { location } = this.props
    return items.reduce((accumulator, item, index) => {
      let show = true
      const active = location.pathname === item.link
      if (item.authority) {
        show = false
        const authorities = Array.isArray(item.authority) ? item.authority : [item.authority]
        for (const authority of authorities) {
          if (can(authority)) {
            show = true
            break
          }
        }
      }
      if (!show) return accumulator
      accumulator.push(
        <div key={index} className={cx('item', { active })}>
          <Link to={{ pathname: item.link, state: { active: item.name } }}>
            <i className={cx('icon', item.icon)}></i>{item.name}
          </Link>
        </div>
      )
      return accumulator
    }, [])
  }

  renderLinkGroup() {
    return items.reduce((accumulator, item, index) => {
      accumulator.push(
        <div key={index} className="item">
          <a>{item.name}</a>
          <div className="menu">
            {this.renderLinkItems(item.children)}
          </div>
        </div>
      )
      return accumulator
    }, [])
  }

  render() {
    const { currentUser, handleLogout } = this.props

    // 用户可能没头像
    let avatar
    if (currentUser.avatar) {
      avatar = (
        <img
          className="ui avatar image"
          role="presentation"
          src={scale(currentUser.avatar, '100x100')}
        />
      )
    }
    return (
      <div className={styles.toc}>
        <div className={cx(styles.tocUiSidebar, 'ui visible inverted left vertical sidebar menu')}>
          <div className="item">
            <Logo className="ui logo icon image" width="50" />
          </div>
          <div className={cx('item', styles.userInfo)}>
            {avatar}
            <span>{currentUser.name}</span>
          </div>
          {this.renderLinkGroup()}
          <div className="item">
            <a href="" onClick={handleLogout}>
              <i className="icon power"></i>退出
            </a>
          </div>
        </div>
      </div>
    )
  }
}
