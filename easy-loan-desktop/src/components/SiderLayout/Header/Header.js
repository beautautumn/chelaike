import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router';
import { Layout, Icon, Avatar, Breadcrumb } from 'antd';
import styles from './Header.scss';

const Header = ({
  toggleSider,
  siderCollapsed,
  menuData,
  location,
  logout,
  currentUser,
  pageTitle
}) => {
  const matchPathMenus = [];
  const matchPath = (path, menus) => {
    for (let i = 0; i < menus.length; ++i) {
      const menu = menus[i];
      if ((matchPath(path, menu.children || [])) ||
          menu.path === path ||
          (menu.path instanceof RegExp && path.match(menu.path))) {
        matchPathMenus.push(menu)
        return true
      }
    }
    return false
  };
  if (!matchPath(location.pathname, menuData, true)) {
    matchPathMenus.length = 0;
  } else {
    matchPathMenus.reverse();
  }

  return (
    <Layout.Header className={styles.header}>
      <Icon
        className={styles.trigger}
        type={siderCollapsed ? 'menu-unfold' : 'menu-fold'}
        onClick={toggleSider}
      />
      <Breadcrumb className={styles.breadcrumb}>
        <Breadcrumb.Item>
          <Icon type="home" />
        </Breadcrumb.Item>
        {matchPathMenus.length > 0 &&
          matchPathMenus.map(menu => (
            <Breadcrumb.Item key={menu.key}>
              <Icon type={menu.icon} />
              <span>
                {menu.path instanceof RegExp ? pageTitle : menu.text}
              </span>
            </Breadcrumb.Item>
          ))}
      </Breadcrumb>
      <div className={styles.user}>
        <Avatar size="large" className={styles.avatar}>
          {currentUser.name && currentUser.name[0]}
        </Avatar>
        <div className={styles.info}>
          <div>{currentUser.name}</div>
          <a onClick={() => logout()}>退出登录</a>
        </div>
      </div>
    </Layout.Header>
  );
};

Header.propTypes = {
  toggleSider: PropTypes.func.isRequired,
  siderCollapsed: PropTypes.bool.isRequired,
  location: PropTypes.object.isRequired,
  logout: PropTypes.func.isRequired,
  currentUser: PropTypes.object.isRequired
};

export default withRouter(Header);
