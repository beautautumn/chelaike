import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Role from 'models/role'
import { Link } from 'react-router'
import List from './List'
import Helmet from 'react-helmet'

@connect(
  _state => ({
    roles: Role.select('list'),
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    roles: PropTypes.array.isRequired,
  }

  componentWillMount() {
    const { dispatch } = this.props
    dispatch(Role.fetch())
  }

  handleDestroy = id => () => {
    const { dispatch } = this.props
    dispatch(Role.destroy(id))
  }

  render() {
    const { roles } = this.props

    return (
      <div>
        <Helmet title="角色管理" />

        <Link className="ant-btn ant-btn-primary ant-btn-lg" to="/roles/new">新增角色</Link>

        <List
          roles={roles}
          handleDestroy={this.handleDestroy}
        />
      </div>
    )
  }
}
