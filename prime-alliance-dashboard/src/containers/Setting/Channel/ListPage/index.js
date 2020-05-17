import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import Channel from 'models/channel'
import { Button } from 'antd'
import { EditModal } from '..'
import List from './List'
import Helmet from 'react-helmet'

@connect(
  _state => ({
    channels: Channel.select('list'),
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    channels: PropTypes.array.isRequired,
    history: PropTypes.object,
  }

  componentWillMount() {
    this.props.dispatch(Channel.fetch())
  }

  handleDestroy = ({ id }) => () => {
    this.props.dispatch(Channel.destroy(id))
  }

  handleNew = () => {
    const { dispatch } = this.props
    dispatch(showModal('channelEdit'))
  }

  handleEdit = id => event => {
    const { dispatch } = this.props
    event.preventDefault()
    dispatch(showModal('channelEdit', { id }))
  }

  render() {
    const { channels } = this.props
    return (
      <div>
        <Helmet title="业务设置" />

        <EditModal />

        <Button type="primary" size="large" onClick={this.handleNew}>新增渠道</Button>

        <List
          channels={channels}
          handleEdit={this.handleEdit}
          handleDestroy={this.handleDestroy}
        />
      </div>
    )
  }
}
