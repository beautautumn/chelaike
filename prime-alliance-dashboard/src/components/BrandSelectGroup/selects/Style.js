import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class StyleSelect extends Component {
  static propTypes = {
    value: PropTypes.string,
    onChange: PropTypes.func,
  }

  static contextTypes = {
    styles: PropTypes.array,
    resetStyles: PropTypes.bool,
  }

  componentDidUpdate() {
    if (this.context.resetStyles) {
      this.props.onChange('')
    }
  }

  render() {
    const styles = this.context.styles || []
    const currentValue = this.props.value
    let exists = false

    const items = styles.map(style => {
      if (style.name === currentValue) {
        exists = true
      }
      return {
        value: style.name,
        text: style.name,
      }
    })

    if (!exists && currentValue) {
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
