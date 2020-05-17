import React from 'react'
import PropTypes from 'prop-types'
import { withRouter } from 'react-router'
import { Link } from 'react-router-dom'
import { Layout, Menu, Icon } from 'antd'
import styles from './Sider.scss'
import logo from './logo.png'

const Sider = ({ menuData, collapsed, location }) => {
  const createMenuItem = (data, isRoot = false) => {
    if (data.path) {
      if (data.path === location.pathname) selectKey = data.key
      return (
        <Menu.Item key={data.key}>
          <Link to={data.path}>
            {data.icon && <Icon type={data.icon} />}
            <span className={isRoot ? 'nav-text' : null}>{data.text}</span>
          </Link>
        </Menu.Item>
      )
    }
    return (
      <Menu.SubMenu
        key={data.key}
        title={
          <span>
            {data.icon && <Icon type={data.icon} />}
            <span className={isRoot ? 'nav-text' : null}>{data.text}</span>
          </span>
        }
      >
        {data.children && data.children.map((child) => createMenuItem(child))}
      </Menu.SubMenu>
    )
  }

  let selectKey = ''
  const menuItems = menuData && menuData.map((m) => createMenuItem(m, true))

  return (
    <Layout.Sider
      collapsed={collapsed}
      trigger={null}
      collapsible
      className="easy-loan-layout-sider"
    >
      <div className={styles.logo} >
        <img src={logo} alt="logo" />
        <span className="brand-name">车融易</span>
      </div>
      <Menu theme="dark" mode={collapsed ? 'vertical' : 'inline'} defaultSelectedKeys={[selectKey]}>
        {menuItems}
      </Menu>
    </Layout.Sider>
  )
}

Sider.__ANT_LAYOUT_SIDER = true;

Sider.defaultProps = {
  collapsed: true
}

Sider.propTypes = {
  menuData: PropTypes.array.isRequired,
  collapsed: PropTypes.bool.isRequired,
  location: PropTypes.object.isRequired,
}

export default withRouter(Sider)
