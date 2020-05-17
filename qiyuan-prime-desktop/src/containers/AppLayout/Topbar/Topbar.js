import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Link } from 'react-router'
import cx from 'classnames'
import can from 'helpers/can'
import { Menu } from 'antd'
import styles from './Topbar.scss'
import { Logo } from 'components'
import { ChangeModal as ChangePasswordModal } from 'containers/Password'
import Avatar from './Avatar'
// import config from 'config'

const items = [
  {
    name: '客户管理',
    children: [
      { name: '客户跟踪', link: '/intentions/following', icon: 'sitemap' },
      { name: '过期回收', link: '/intentions/recovery', icon: 'recycle' },
      { name: '坐席录入', link: '/intentions/service', icon: 'travel', authority: '坐席录入' },
      { name: '服务预约', link: '/service_appointments', icon: 'phone' }
    ],
  },
  {
    name: '微店管理',
    authority: '微店管理权限',
    children: [
      { name: '绑定公众号', link: '/weshop/binding', icon: 'qrcode', authority: '微店管理权限' },
      { name: '自定义菜单', link: '/weshop/custom_menu', icon: 'mobile', authority: '微店管理权限' }
    ],
  },
  {
    name: '系统管理',
    children: [
      { name: '业务设置', link: '/setting', icon: 'setting', authority: '业务设置' },
    ]
  },
]

export default class Topbar extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    handleShowModal: PropTypes.func.isRequired,
    handleLogout: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    const initState = {
      currentMenuName: null,
      currentItemName: null,
      currentGroupName: null
    }
    this.state = this.matchGroupAndItem(props.location) || initState
  }

  matchGroupAndItem = (location) => {
    let state = null
    items.forEach((group) => {
      group.children.forEach((item) => {
        if (location.pathname && location.pathname.startsWith(item.link)) {
          state = {
            currentMenuName: group.name,
            currentItemName: item.name,
            currentGroupName: group.name
          }
          return
        }
      })
      if (state) return
    })
    return state
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location !== nextProps.location) {
      const { location } = nextProps
      const state = this.matchGroupAndItem(location)
      if (state) this.setState(state)
    }
  }

  renderLinkItems(items) {
    return items.reduce((accumulator, item) => {
      if (!this.checkAuthority(item)) return accumulator
      const link = this.state.currentItemName === item.name ? (
        <div><i className={cx('icon', item.icon)}></i>{item.name}</div>
      ) : (
        <Link to={{ pathname: item.link, state: { active: item.name } }}>
          <i className={cx('icon', item.icon)}></i>{item.name}
        </Link>
      )
      accumulator.push(
        <Menu.Item key={item.name}>
          {link}
        </Menu.Item>
     )
      return accumulator
    }, [])
  }

  renderLinkGroup() {
    return items.reduce((accumulator, item) => {
      if (!this.checkAuthority(item)) return accumulator
      accumulator.push(
        <Menu.Item key={item.name}>{item.name}</Menu.Item>
      )
      return accumulator
    }, [])
  }

  checkAuthority(item) {
    if (item.authority) {
      let show = false
      const authorities = Array.isArray(item.authority) ? item.authority : [item.authority]
      for (const authority of authorities) {
        if (can(authority)) {
          show = true
          break
        }
      }
      return show
    }
    return true
  }

  handleGroupClick = (event) => {
    this.setState({
      ...this.state,
      currentMenuName: event.key
    })
  }

  handleItemClick = (event) => {
    this.setState({
      ...this.state,
      currentItemName: event.key,
      currentGroupName: this.state.currentMenuName
    })
  }

  render() {
    const { currentUser, handleLogout, handleShowModal } = this.props

    const menuItem = items.filter((item) => item.name === this.state.currentMenuName)
    const submenuItems = menuItem.length > 0 ? menuItem[0].children : []

    return (
      <div className={styles.topbar}>
        <div className={styles.header}>
          <div className={styles.wrapper}>
            <div className={styles.logo}>
              <Logo />
            </div>
            <Avatar currentUser={currentUser} showModal={handleShowModal} logout={handleLogout} />
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
        <ChangePasswordModal />
      </div>
    )
  }
}
