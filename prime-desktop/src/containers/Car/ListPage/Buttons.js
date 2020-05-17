import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Link } from 'react-router'
import { exportLink } from 'helpers/car'
import can from 'helpers/can'

export default class Buttons extends PureComponent {
  static propTypes = {
    searchQuery: PropTypes.object,
    currentUser: PropTypes.object.isRequired
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
        </div>
      </div>
    )
  }
}
