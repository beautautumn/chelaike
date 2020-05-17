import React, { Component, PropTypes } from 'react'
import { Link } from 'react-router'
import date from 'helpers/date'
import { Dropdown } from 'components'
import { Popconfirm } from 'antd'

export default class Item extends Component {
  static propTypes = {
    role: PropTypes.object.isRequired,
    handleDestroy: PropTypes.func.isRequired
  }

  render() {
    const { role, handleDestroy } = this.props
    return (
      <tr>
        <td>{role.name}</td>
        <td>{role.note}</td>
        <td>{date(role.createdAt)}</td>
        <td>
          <Dropdown options={{ action: 'hide' }}>
            <div className="ui floating tiny teal dropdown button">
              <div className="text">操作</div>
              <i className="dropdown icon"></i>
              <div className="menu">
                <Link className="item text" to={`/roles/${role.id}/edit`}>
                  编辑
                </Link>
                <Popconfirm title={`删除角色：${role.name}`} onConfirm={handleDestroy(role)}>
                  <div className="item">
                    删除
                  </div>
                </Popconfirm>
              </div>
            </div>
          </Dropdown>
        </td>
      </tr>
    )
  }
}
