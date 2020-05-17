import React, { Component, PropTypes } from 'react'
import date from 'helpers/date'
import { Dropdown } from 'components'

export default class Item extends Component {
  static propTypes = {
    cooperationCompany: PropTypes.object.isRequired,
    handleDestroy: PropTypes.func.isRequired,
    handleEdit: PropTypes.func.isRequired
  }

  render() {
    const { cooperationCompany, handleEdit, handleDestroy } = this.props

    return (
      <tr>
        <td>{cooperationCompany.name}</td>
        <td>{date(cooperationCompany.createdAt)}</td>
        <td>
          <Dropdown options={{ action: 'hide' }}>
            <div className="ui floating tiny teal dropdown button">
              <div className="text">操作</div>
              <i className="dropdown icon"></i>
              <div className="menu">
                <a className="ui item" onClick={handleEdit(cooperationCompany.id)}>
                  编辑
                </a>
                <div className="item" onClick={handleDestroy(cooperationCompany)}>
                  删除
                </div>
              </div>
            </div>
          </Dropdown>
        </td>
      </tr>
    )
  }
}
