import React, { Component, PropTypes } from 'react'
import { DatePicker } from 'antd'
import moment from 'moment'

const formatStrings = {
  datetime: 'YYYY-MM-DD HH:mm:ss',
  date: 'YYYY-MM-DD',
  month: 'YYYY-MM'
}

export default class Datepicker extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func,
    format: PropTypes.string,
    size: PropTypes.string,
    min: PropTypes.object,
    max: PropTypes.object
  }

  static defaultProps = {
    format: 'date',
    size: 'large',
    time: false,
    onChange: () => {}
  }

  disabledDate = (date) => {
    if (!date) {
      return false
    }
    const { min, max } = this.props
    const startResult = min && date.isBefore(moment(min))
    const endResult = max && date.isAfter(moment(max))
    return startResult || endResult
  }

  handleChange = (date) => {
    let dateStr = ''
    const { format } = this.props

    if (date && format) dateStr = moment(date).format(formatStrings[format])

    this.props.onChange(dateStr)
  }

  render() {
    const { defaultValue, value, format, size } = this.props

    const Picker = format === 'month' ? DatePicker.MonthPicker : DatePicker
    const showTime = format === 'datetime'
    const innerFormat = formatStrings[format]
    const defaultValueDate = defaultValue ? moment(defaultValue, innerFormat) : null
    const valueDate = value ? moment(value, innerFormat) : null

    return (
      <Picker
        {...this.props}
        size={size}
        disabledDate={this.disabledDate}
        defaultValue={defaultValueDate}
        value={valueDate}
        onChange={this.handleChange}
        showTime={showTime}
        format={innerFormat}
      />
    )
  }
}

