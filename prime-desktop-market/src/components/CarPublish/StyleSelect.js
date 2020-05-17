import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class StyleSelect extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func
  }

  static contextTypes = {
    styles: PropTypes.array,
    resetSeries: PropTypes.bool
  }

  componentDidUpdate() {
    if (this.context.resetStyles) {
      this.props.onChange('')
    }
  }

  render() {
    const styles = this.context.styles || []
    const currentValue = this.props.value || this.props.defaultValue
    let exists = false

    const items = styles.map(style => {
      if (style.name === currentValue) {
        exists = true
      }
      return {
        value: style.value,
        text: style.name
      }
    })

    if (!exists) {
      items.unshift({ value: currentValue, text: currentValue })
    }

    return (
      <Select
        items={items}
        prompt="选择款式"
        {...this.props}
      />
    )
  }
}
