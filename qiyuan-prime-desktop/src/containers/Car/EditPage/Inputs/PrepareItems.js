import React, { Component, PropTypes } from 'react'
import Textarea from 'react-textarea-autosize'
import { Col, Input, Form, Button, Icon } from 'antd'

import { NumberInput } from '@prime/components'

export default class ItemsForm extends Component {
  static propTypes = {
    defaultValue: PropTypes.array,
    value: PropTypes.array,
    onChange: PropTypes.func
  }

  constructor(props) {
    super(props)

    this.state = {
      items: props.value || props.defaultValue || []
    }
  }

  handleAdd = () => {
    this.setState({
      items: [
        ...this.state.items,
        { name: '', amountYuan: '', note: '' }
      ]
    }, () => this.props.onChange(this.state.items))
  }

  handleRemove = (index) => () => {
    this.state.items[index]._destroy = true // eslint-disable-line
    this.setState({
      items: [
        ...this.state.items
      ]
    }, () => this.props.onChange(this.state.items))
  }

  handleChange = (index, field) => (event) => {
    const value = event.currentTarget.value
    const newItem = { ...this.state.items[index] }
    newItem[field] = value
    const newItems = [...this.state.items]
    newItems[index] = newItem
    this.setState({
      items: newItems
    }, () => this.props.onChange(this.state.items))
  }

  render() {
    const { items } = this.state

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 },
    }

    return (
      <div>
      {items.reduce((pre, item, index) => {
        if (item._destroy) { // eslint-disable-line
          return pre
        }
        pre.push((
          <Form.Item {...formItemLayout} key={index + 'a'} label="整备项目：">
            <Col span="11">
              <Input value={item.name} onChange={this.handleChange(index, 'name')} />
            </Col>
            <Col span="10" offset="1">
              <NumberInput
                placeholder="费用："
                value={item.amountYuan}
                onChange={this.handleChange(index, 'amountYuan')}
              />
            </Col>
            <Col span="1" offset="1">
              <Button
                type="primary"
                size="large"
                onClick={this.handleRemove(index)}
              >
                <Icon type="minus" />
              </Button>
            </Col>
          </Form.Item>
        ))
        pre.push(
          <Form.Item {...formItemLayout} key={index + 'b'} label="整备说明：">
            <Textarea
              className="ant-input ant-input-lg"
              rows={1}
              value={item.note}
              onChange={this.handleChange(index, 'note')}
            />
          </Form.Item>
        )
        return pre
      }, [])}

        <Form.Item {...formItemLayout} label=" ">
          <Button type="primary" size="large" onClick={this.handleAdd}>
            <Icon type="plus" />
            新增整备项目
          </Button>
        </Form.Item>
      </div>
    )
  }
}
