import React, { PropTypes } from 'react'
import { scale } from 'helpers/image'
import { Menu, Dropdown, Icon } from 'antd'
import defaultAvatar from './avatar.png'
import styles from '../style.scss'

export default function Avatar({ currentUser, logout }) {
  const avatarUrl = currentUser.avatar ? scale(currentUser.avatar, '100x100') : defaultAvatar
  const avatar = <img alt={currentUser.name} src={avatarUrl} />
  const menu = (
    <Menu>
      <Menu.Item>
        <a onClick={logout}>
          <Icon type="logout" /> 退出
        </a>
      </Menu.Item>
    </Menu>
  )

  return (
    <Dropdown overlay={menu} trigger={['click']}>
      <a className={styles.avatar}>
        {avatar}
        <span className={styles.name}>{currentUser.name}</span>
        <Icon type="down" />
      </a>
    </Dropdown>
  )
}

Avatar.propTypes = {
  currentUser: PropTypes.object.isRequired,
  logout: PropTypes.func.isRequired,
}
