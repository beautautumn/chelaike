import React, { Component, PropTypes } from 'react'
import { Dropdown } from 'components'

export default class LocationSelect extends Component {
  static propTypes = {
    locations: PropTypes.array.isRequired,
    value: PropTypes.string,
    onChange: PropTypes.func.isRequired
  }

  renderLocations() {
    const { locations } = this.props

    return locations.reduce((accumulator, location, index) => {
      accumulator.push(
        <div key={index} className="item" data-value={location}>
          {location}
        </div>
      )
      return accumulator
    }, [])
  }

  render() {
    const { value, onChange } = this.props

    return (
      <Dropdown options={{ onChange }}>
        <div className="ui dropdown mini button">
          <input type="hidden" value={value} />
          <div className="default text ng-binding">请选择位置</div>
          <div className="menu transition hidden">
            {this.renderLocations()}
          </div>
        </div>
      </Dropdown>
    )
  }
}
