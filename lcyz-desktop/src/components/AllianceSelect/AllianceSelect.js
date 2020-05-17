import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class AllianceSelect extends Component {
  static propTypes = {
    value: PropTypes.string
  }

  static contextTypes = {
    alliances: PropTypes.array.isRequired,
    handleAllianceChange: PropTypes.func.isRequired
  }

  componentDidMount() {
    const { value } = this.props
    // 如果有初始值
    if (value) {
      this.context.handleAllianceChange(value)
    }
  }

  componentWillReceiveProps(nextProps) {
    const currentValue = this.props.value
    const nextValue = nextProps.value
    // 如果值有变化
    if (currentValue !== nextValue && nextValue) {
      this.context.handleAllianceChange(nextValue)
    }
  }

  onChange = (value) => {
    const { onChange } = this.props

    let alliance = this.context.alliances.filter(item => (item.id.toString() === value))

    if (alliance.length > 0) {
      alliance = alliance[0]
    }
    onChange(value, alliance.convention, alliance.name)
  }

  render() {
    const items = this.context.alliances.map((alliance) => ({
      value: alliance.id.toString(),
      text: alliance.name,
    }))

    return (
      <Select
        items={items}
        {...this.props}
        onChange={this.onChange}
        prompt="选择联盟"
      />
    )
  }
}
