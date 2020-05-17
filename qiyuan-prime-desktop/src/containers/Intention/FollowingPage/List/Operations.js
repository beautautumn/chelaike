import React, { Component, PropTypes } from 'react'
import { Menu, Dropdown, Icon } from 'antd'

export default class Operations extends Component {
  static propTypes = {
    intention: PropTypes.object.isRequired,
    canPush: PropTypes.bool.isRequired,
    canShare: PropTypes.bool.isRequired,
    handleEdit: PropTypes.func.isRequired,
    handlePush: PropTypes.func.isRequired,
    handleShare: PropTypes.func.isRequired
  }

  render() {
    const {
      intention,
      canPush,
      handleEdit,
      handlePush,
    } = this.props
    const menus = []

    if (canPush) {
      menus.push(
        <Menu.Item key="push">
          <a onClick={handlePush(intention.id)}>跟进</a>
        </Menu.Item>
      )
    }

    menus.push(
      <Menu.Item key="edit">
        <a onClick={handleEdit(intention.id)}>编辑</a>
      </Menu.Item>
    )

    const menu = <Menu>{menus}</Menu>

    return (
      <Dropdown overlay={menu} trigger={['click']}>
        <a className="ant-dropdown-link" href="#" onClick={event => event.preventDefault()}>
          操作 <Icon type="down" />
        </a>
      </Dropdown>
    )
  }
}
