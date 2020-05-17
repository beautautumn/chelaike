import React, { Component, PropTypes } from 'react'
import { DatePicker } from 'antd'
import moment from 'moment'

const formatStrings = {
  datetime: 'yyyy-MM-dd HH:mm:ss',
  date: 'yyyy-MM-dd',
  month: 'yyyy-MM',
}

export default class Datepicker extends Component {
  static propTypes = {
    defaultValue: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func,
    format: PropTypes.string,
    size: PropTypes.string,
    min: PropTypes.object,
    max: PropTypes.object,
  }

  static defaultProps = {
    size: 'large',
    time: false,
    onChange: () => {},
  }

  disabledDate = (date) => {
    if (!date) {
      return false
    }
    const { min, max } = this.props
    const startResult = min && date.getTime() < moment(min).startOf('day').toDate()
    const endResult = max && date.getTime() > moment(max).endOf('day').toDate()
    return startResult || endResult
  }

  handleChange = (date) => {
    let dateStr = ''
    const { format } = this.props

    if (date && format === 'month') {
      dateStr = moment(date).format('YYYY-MM')
    } else if (date && format === 'datetime') {
      dateStr = moment(date).format('YYYY-MM-DD hh:mm:ss')
    } else if (date) {
      dateStr = moment(date).format('YYYY-MM-DD')
    }
    this.props.onChange(dateStr)
  }

  render() {
    const { defaultValue, value, format, size } = this.props
    const defaultValueDate = defaultValue ? new Date(defaultValue) : null
    const valueDate = value ? new Date(value) : null
    let innerFormat = formatStrings.date
    let Picker = DatePicker
    let showTime = false
    if (format === 'datetime') {
      innerFormat = formatStrings.datetime
      showTime = true
    } else if (format === 'month') {
      innerFormat = formatStrings.month
      Picker = DatePicker.MonthPicker
    }
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
