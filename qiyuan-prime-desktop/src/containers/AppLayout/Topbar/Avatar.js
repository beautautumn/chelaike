import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import styles from './Topbar.scss'
import { scale } from 'helpers/image'
import defaultAvatar from './defaultAvatar.png'
import { Menu, Dropdown, Icon } from 'antd'

export default class Avatar extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    showModal: PropTypes.func.isRequired,
    logout: PropTypes.func.isRequired,
  }

  handleChangePassword = () => {
    this.props.showModal('passwordChange')
  }

  render() {
    const { currentUser } = this.props

    const avatarUrl = currentUser.avatar ? scale(currentUser.avatar, '100x100') : defaultAvatar
    const avatar = <img role="presentation" src={avatarUrl} />
    const menu = (
      <Menu>
        <Menu.Item key="0">
          <a onClick={this.handleChangePassword}>
            <Icon type="user" /> 修改密码
          </a>
        </Menu.Item>
        <Menu.Item key="1">
          <a onClick={this.props.logout}>
            <Icon type="logout" /> 退出
          </a>
        </Menu.Item>
      </Menu>
    )

    return (
      <Dropdown overlay={menu} trigger={['click']}>
        <a className={styles.avatar}>
          {avatar}
          <span>{currentUser.name + ' '}</span>
          <Icon type="down" />
        </a>
      </Dropdown>
    )
  }
}
