import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class CitySelect extends Component {
  static propTypes = {
    onChange: PropTypes.func,
  }

  static contextTypes = {
    cities: PropTypes.array,
    resetCities: PropTypes.bool,
  }

  componentDidUpdate() {
    if (this.context.resetCities) {
      this.props.onChange('')
    }
  }

  render() {
    const cities = this.context.cities || []

    const items = cities.map((province) => (
      { value: province.name, text: province.name }
    ))

    return (
      <Select
        ref="select"
        items={items}
        prompt="选择城市"
        {...this.props}
      />
    )
  }
}
