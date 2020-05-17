import React, { Component, PropTypes } from 'react'
import { Menu, Dropdown, Icon } from 'antd'
import can from 'helpers/can'
import config from 'config'

/*eslint-disable*/
function imagesDownloadLink(car, user) {
  return `${config.serverUrl}${config.basePath}/cars/${car.id}/images_download?download_type=transfer&AutobotsToken=${user.token}`
}
/*eslint-enable*/

export default class Operations extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    handleShowModal: PropTypes.func.isRequired
  }

  render() {
    const { car, currentUser, handleShowModal } = this.props

    const menus = []

    if (can('牌证信息录入', null, car.shopId)) {
      menus.push(
        <Menu.Item key="license">
          <a href="#" onClick={handleShowModal('licenseEdit', car.id)}>编辑牌证</a>
        </Menu.Item>
      )
    }

    if (can('证件资料导出', null, car.shopId)) {
      menus.push(
        <Menu.Item key="export">
          <a href={imagesDownloadLink(car, currentUser)}>证件下载</a>
        </Menu.Item>
      )
    }

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
