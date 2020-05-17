import React, { Component, PropTypes } from 'react'
import { Menu, Dropdown, Icon } from 'antd'
import can from 'helpers/can'
import { Link } from 'react-router'

const items = [
  // { modal: 'carRefund', text: '车辆回库', authority: '出库车辆回库' },
  { modal: 'licenseEdit', text: '编辑牌证', authority: '牌证信息录入' },
  { modal: 'prepareRecordEdit', text: '整备编辑', authority: '整备信息录入' }
]

export default class Operations extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    handleShowModal: PropTypes.func.isRequired
  }

  render() {
    const { car, handleShowModal } = this.props
    const menus = items.reduce((acc, item, index) => {
      if (can(item.authority, null, car.shopId)) {
        acc.push(
          <Menu.Item key={index}>
            <a href="#" onClick={handleShowModal(item.modal, { id: car.id })}>
              {item.text}
            </a>
          </Menu.Item>
        )
      }
      return acc
    }, [])

    if (can('在库车辆出库', null, car.shopId)) {
      menus.push(
        <Menu.Item key="stockOut">
          <a href="#" onClick={handleShowModal('carStockOut', { id: car.id, action: 'edit' })}>
            编辑出库
          </a>
        </Menu.Item>
      )
    }

    if (can('出库车辆回库', null, car.shopId) && car.state !== 'alliance_stocked_out') {
      menus.push(
        <Menu.Item key="carRefund">
          <a href="#" onClick={handleShowModal('carRefund', { id: car.id })}>
            车辆回库
          </a>
        </Menu.Item>
      )
    }

    if (can('出库车辆编辑', null, car.shopId)) {
      menus.unshift(
        <Menu.Item key="edit">
          <Link to={`/stock_out_cars/${car.id}/edit`}>编辑车辆</Link>
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
