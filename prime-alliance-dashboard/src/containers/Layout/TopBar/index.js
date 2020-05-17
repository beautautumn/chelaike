import React, { Component, PropTypes } from 'react'
import { Link } from 'react-router'
import cx from 'classnames'
import can from 'helpers/can'
import { Menu } from 'antd'
import styles from './style.scss'
import Avatar from './Avatar'

const items = [
  {
    name: '车辆管理',
    children: [
      { name: '在库车辆', link: '/cars', authority: '在库车辆查询' },
      { name: '出库车辆', link: '/stock_out_cars', authority: '已出库车辆查询' },
    ],
  },
  {
    name: '客户管理',
    children: [
      { name: '客户跟踪', link: '/intentions' },
    ],
  },
  {
    name: '系统配置',
    children: [
      { name: '联盟信息', link: '/alliance', authority: '联盟管理' },
      { name: '角色管理', link: '/roles', authority: '角色管理' },
      { name: '员工管理', link: '/users', authority: '员工管理' },
      { name: '业务设置', link: '/setting', authority: '业务设置' },
    ],
  },
]

export default class TopBar extends Component {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    handleLogout: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = this.matchGroupAndItem(props.location)
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location !== nextProps.location) {
      const { location } = nextProps
      const state = this.matchGroupAndItem(location)
      if (state) this.setState(state)
    }
  }

  matchGroupAndItem = (location) => {
    let state = null
    items.forEach((group) => {
      group.children.forEach((item) => {
        if (location.pathname && location.pathname.startsWith(item.link)) {
          state = {
            currentMenuName: group.name,
            currentItemName: item.name,
            currentGroupName: group.name,
          }
        }
      })
    })
    return state
  }

  handleGroupClick = (event) => {
    this.setState({
      ...this.state,
      currentMenuName: event.key,
    })
  }

  handleItemClick = (event) => {
    this.setState({
      ...this.state,
      currentItemName: event.key,
      currentGroupName: this.state.currentMenuName,
    })
  }

  renderLinkItems(items) {
    return items.reduce((accumulator, item) => {
      let show = true
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
        <Menu.Item key={item.name}>
          <Link to={{ pathname: item.link, state: { active: item.name } }}>
            <i className={cx('icon', item.icon)}></i>{item.name}
          </Link>
        </Menu.Item>
      )
      return accumulator
    }, [])
  }

  renderLinkGroup() {
    return items.reduce((accumulator, item) => {
      accumulator.push(
        <Menu.Item key={item.name}>{item.name}</Menu.Item>
      )
      return accumulator
    }, [])
  }

  render() {
    const { currentUser, handleLogout } = this.props

    const menuItem = items.filter((item) => item.name === this.state.currentMenuName)
    const submenuItems = menuItem.length > 0 ? menuItem[0].children : []

    return (
      <div className={styles.topbar}>
        <div className={styles.header}>
          <div className={styles.wrapper}>
            <div className={styles.logo}>
              <Link to="/">联盟管理</Link>
            </div>
            <Avatar currentUser={currentUser} logout={handleLogout} />
            <Menu
              onClick={this.handleGroupClick}
              theme="dark" mode="horizontal"
              selectedKeys={[this.state.currentMenuName]}
              className={styles.menu}
            >
              {this.renderLinkGroup()}
            </Menu>
          </div>
        </div>
        <div className={styles.subheader}>
          <div className={styles.wrapper}>
            <Menu
              onClick={this.handleItemClick}
              mode="horizontal"
              selectedKeys={[this.state.currentItemName]}
              className={styles.submenu}
            >
              {this.renderLinkItems(submenuItems)}
            </Menu>
          </div>
        </div>
      </div>
    )
  }
}
