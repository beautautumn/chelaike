import React, { Component, PropTypes } from 'react'
import { FormItem, StyleSelect } from 'components'
import { Col, Input, Checkbox } from 'antd'

export default class Style extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props)

    this.state = { system: true }
  }

  handleChange = (event) => {
    this.setState({ system: event.target.checked })
  }

  render() {
    const { field } = this.props
    const { system } = this.state

    return (
      <FormItem field={field} required>
        <Col span="18">
          {system ?
            <StyleSelect {...field} emptyText="年款暂不确定" /> :
            <Input type="text" {...field} />
          }
        </Col>
        <Col span="5" offset="1">
          <label>
            <Checkbox checked={system} onChange={this.handleChange} />
            {system ? '系统款式' : '手动输入'}
          </label>
        </Col>
      </FormItem>
    )
  }
}
