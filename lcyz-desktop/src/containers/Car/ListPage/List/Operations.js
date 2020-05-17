import React, { Component, PropTypes } from 'react'
import { Menu, Dropdown, Icon, Popconfirm } from 'antd'
import can from 'helpers/can'
import config from 'config'
import { Link } from 'react-router'

/*eslint-disable*/
function imageDownloadLink(car, user) {
  return `${config.serverUrl}${config.basePath}/cars/${car.id}/images_download?download_type=car&image_type=water_mark&AutobotsToken=${user.token}`
}
/*eslint-enable*/

export default class Operations extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    handleDestroy: PropTypes.func.isRequired,
    handleShowModal: PropTypes.func.isRequired
  }

  render() {
    const { currentUser, car, handleShowModal, handleDestroy } = this.props
    const menus = []

    if (can('车辆信息编辑', null, car.shopId)) {
      menus.push(
        <Menu.Item key="edit">
          <Link to={`/cars/${car.id}/edit`}>编辑车辆</Link>
        </Menu.Item>
      )
      menus.push(
        <Menu.Item key="detection">
          <a href="#" onClick={handleShowModal('carDetectionEdit', car.id)}>检测报告</a>
        </Menu.Item>
      )
    }

    if (can('车辆状态修改', null, car.shopId)) {
      menus.push(
        <Menu.Item key="state">
          <a href="#" onClick={handleShowModal('carStateEdit', car.id)}>修改状态</a>
        </Menu.Item>
      )
    }

    if (can('车辆销售定价', null, car.shopId)) {
      menus.push(
        <Menu.Item key="price">
          <a href="#" onClick={handleShowModal('carPriceEdit', car.id)}>销售定价</a>
        </Menu.Item>
      )
    }

    if (can('在库车辆预定', null, car.shopId)) {
      if (!car.reserved) {
        menus.push(
          <Menu.Item key="reserve">
            <a href="#" onClick={handleShowModal('carReserve', car.id)}>车辆预定</a>
          </Menu.Item>
        )
      }
      if (car.reserved) {
        menus.push(
          <Menu.Item key="reserve">
            <a href="#" onClick={handleShowModal('carReserve', car.id)}>编辑预定</a>
          </Menu.Item>
        )
        menus.push(
          <Menu.Item key="cancelReserve">
            <a href="#" onClick={handleShowModal('carReservationCancel', car.id)}>取消预定</a>
          </Menu.Item>
        )
      }
    }

    if (can('在库车辆出库', null, car.shopId)) {
      menus.push(
        <Menu.Item key="stockOut">
          <a href="#" onClick={handleShowModal('carStockOut', car.id)}>车辆出库</a>
        </Menu.Item>
      )
    }

    [
      <a
        href={`${config.serverUrl}/cars/${car.id}/price_tag`}
        target="_blank"
        data-shell-external
      >
        打印价签
      </a>,
      <a href={imageDownloadLink(car, currentUser)}>图片下载</a>
    ].map((link, index) => menus.push(<Menu.Item key={index}>{link}</Menu.Item>))

    if (can('在库车辆删除', null, car.shopId)) {
      menus.push(
        <Menu.Item key="delete">
          <Popconfirm title={'删除车辆：' + car.systemName} onConfirm={handleDestroy(car)}>
            <a href="#">删除车辆</a>
          </Popconfirm>
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
