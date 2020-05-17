import React, { Component, PropTypes } from 'react'
import { Radio } from 'antd'

export default class RadioGroup extends Component {
  static propTypes = {
    onChange: PropTypes.func,
    children: PropTypes.any,
  }

  static defaultProps = {
    onChange: () => {},
  }

  handleChange = event => this.props.onChange(event.target.value)

  render() {
    return (
      <Radio.Group {...this.props} onChange={this.handleChange}>
        {this.props.children}
      </Radio.Group>
    )
  }
}
