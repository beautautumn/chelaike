import React, { Component, PropTypes } from 'react'
import { FormItem } from 'components'
import { Row, Col, Button, Input, Icon } from 'antd'

export default class DeviceNumbersInput extends Component {
  static propTypes = {
    defaultValue: PropTypes.array,
    value: PropTypes.array,
    onChange: PropTypes.func.isRequired,
    onFocus: PropTypes.func.isRequired,
    onBlur: PropTypes.func.isRequired,
    touched: PropTypes.bool,
    valid: PropTypes.bool,
    error: PropTypes.string
  }

  handleChange = (index) => (event) => {
    this.value[index] = event.target.value
    this.props.onChange(this.value)
  }

  handleAdd = () => {
    this.value.push('')
    this.props.onChange(this.value)
  }

  handleRemove = (index) => () => {
    delete this.value[index]
    this.props.onChange(this.value)
  }

  handleFocus = () => {
    this.props.onFocus()
  }

  handleBlur = () => {
    this.props.onBlur()
  }

  render() {
    this.value = this.props.value || this.props.defaultValue
    this.value = this.value || ['']

    const formItemLayout = {
      wrapperCol: { span: 22, offset: 2 }
    }

    return (
      <div>
        {
          this.value.map((number, index) => (
            <FormItem {...formItemLayout} key={index}>
              <Row>
                <Col span="21">
                  <Input
                    type="text"
                    placeholder="设备号"
                    onChange={this.handleChange(index)}
                    onFocus={this.handleFocus}
                    onBlur={this.handleBlur}
                    value={number}
                  />
                </Col>
                <Col span="2" offset="1">
                  <Button size="large" onClick={this.handleRemove(index)}>
                    <Icon type="minus" />
                  </Button>
                </Col>
              </Row>
            </FormItem>
          ))
        }

        <FormItem {...formItemLayout}>
          <Button type="primary" size="large" onClick={this.handleAdd}>
            <Icon type="plus" />
          </Button>
        </FormItem>
      </div>
    )
  }
}
