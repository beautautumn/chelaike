import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import Level from 'models/intention/level'
import { Button } from 'antd'
import { EditModal } from '..'
import List from './List'
import Helmet from 'react-helmet'

@connect(
  _state => ({
    levels: Level.select('list'),
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    levels: PropTypes.array.isRequired,
    history: PropTypes.object,
  }

  componentWillMount() {
    this.props.dispatch(Level.fetch())
  }

  handleDestroy = ({ id }) => () => {
    this.props.dispatch(Level.destroy(id))
  }

  handleNew = () => {
    const { dispatch } = this.props
    dispatch(showModal('levelEdit'))
  }

  handleEdit = id => event => {
    const { dispatch } = this.props
    event.preventDefault()
    dispatch(showModal('levelEdit', { id }))
  }

  render() {
    const { levels } = this.props
    return (
      <div>
        <Helmet title="客户等级" />

        <EditModal />

        <Button type="primary" size="large" onClick={this.handleNew}>新增客户等级</Button>

        <List
          levels={levels}
          handleEdit={this.handleEdit}
          handleDestroy={this.handleDestroy}
        />
      </div>
    )
  }
}
