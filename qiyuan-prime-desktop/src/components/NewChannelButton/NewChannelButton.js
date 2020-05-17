import React, { Component, PropTypes } from 'react'
import { Popover, Button, Icon, Form, Input } from 'antd'

export default class NewChannelButton extends Component {
  static propTypes = {
    onSubmit: PropTypes.func.isRequired,
    saved: PropTypes.bool
  }

  constructor(props) {
    super(props)

    this.state = { visible: false }
  }

  handleSubmit = () => {
    const name = this.refs.name.refs.input.value
    this.props.onSubmit({ name })
    this.setState({
      visible: false
    })
  }

  handleVisibleChange = (visible) => {
    this.setState({ visible })
  }

  render() {
    const content = (
      <Form inline>
        <Form.Item label="新增收购渠道：">
          <Input placeholder="名称" ref="name" />
        </Form.Item>
        <Button type="primary" onClick={() => this.handleSubmit()}>添加</Button>
      </Form>
    )

    return (
      <Popover
        placement="right"
        content={content}
        trigger="click"
        visible={this.state.visible}
        onVisibleChange={this.handleVisibleChange}
      >
        <Button type="primary" size="large">
          <Icon type="plus" />
        </Button>
      </Popover>
    )
  }
}
