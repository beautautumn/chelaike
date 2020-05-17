import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
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
          {can('销售明细导出') &&
            <a
              className="ui button"
              href={exportLink(searchQuery, currentUser, 'cars_out_of_stock')}
            >
              车辆导出
            </a>
          }
        </div>
      </div>
    )
  }
}
