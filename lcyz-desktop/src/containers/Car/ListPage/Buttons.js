import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Link } from 'react-router'
import { exportLink } from 'helpers/car'
import can from 'helpers/can'
import { notification } from 'antd'

export default class Buttons extends PureComponent {
  static propTypes = {
    searchQuery: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    showModal: PropTypes.func.isRequired,
    selectedRowKeys: PropTypes.array.isRequired,
  }

  handleBatchAssign = () => {
    event.preventDefault()
    if (!this.props.selectedRowKeys ||
      this.props.selectedRowKeys.length === 0) {
      notification.warning({
        message: '请选择修改车辆',
        description: '在列表中勾选需要修改的车辆。',
      })
      return
    }
    this.props.showModal('batchAssignAcquirer')
  }

  render() {
    const { searchQuery, currentUser } = this.props
    return (
      <div className="ui grid">
        <div className="ten wide column">
          {can('车辆新增入库') &&
            <Link className="ui blue button" to="/cars/new" >新增入库</Link>
          }
          {can('网站车辆导入') &&
            <Link className="ui button" to="/cars/import">车辆导入</Link>
          }
          {can('库存明细导出') &&
            <a
              className="ui button"
              href={exportLink(searchQuery, currentUser, 'cars_in_stock')}
            >
              车辆导出
            </a>
          }
          {can('车辆信息编辑') &&
            <a
              className="ui button"
              href="#"
              onClick={this.handleBatchAssign}
            >
              车源负责人批量修改
            </a>
          }
        </div>
      </div>
    )
  }
}
