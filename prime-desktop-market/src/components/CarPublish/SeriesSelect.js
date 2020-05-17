import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class SeriesSelect extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func
  }

  static contextTypes = {
    as: PropTypes.string.isRequired,
    series: PropTypes.array,
    resetSeries: PropTypes.bool,
    handleSeriesChange: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { defaultValue } = this.props
    // 如果有初始值
    if (defaultValue) {
      this.context.handleSeriesChange(defaultValue)
    }
  }

  componentWillReceiveProps(nextProps) {
    const { value } = this.props
    // 如果值有变化
    if (value !== nextProps.value && nextProps.value) {
      this.context.handleSeriesChange(nextProps.value)
    }
  }

  componentDidUpdate() {
    if (this.context.resetSeries) {
      this.props.onChange('')
    }
  }

  render() {
    const series = this.context.series || []
    const items = series.map(item => ({
      value: item.value,
      text: item.name
    }))

    return (
      <Select
        ref="select"
        items={items}
        prompt="选择车系"
        {...this.props}
      />
    )
  }
}
