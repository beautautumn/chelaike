import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { reset } from 'redux-form'
import userFactory from 'models/user'
import Entity from 'models/entity'
import EnumValue from 'models/enumValue'
import { Link } from 'react-router'
import SearchBar from './SearchBar'
import List from './List'
import Helmet from 'react-helmet'

const User = userFactory('user::list')

@connect(
  _state => ({
    users: User.select('list'),
    usersById: Entity.getState().users,
    rolesById: Entity.getState().roles,
    enumValues: EnumValue.getState(),
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    users: PropTypes.array.isRequired,
    usersById: PropTypes.object,
    rolesById: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
  }

  componentDidMount() {
    const { dispatch } = this.props
    dispatch(User.fetch())
  }

  handleDestroy = user => () => {
    const { dispatch } = this.props
    dispatch(User.destroy(user.id))
  }

  handleSwitch = user => event => {
    event.preventDefault()
    const { dispatch } = this.props
    user.state = user.state === 'enabled' ? 'disabled' : 'enabled'
    dispatch(User.switchState(user))
  }

  handleSearch = (data) => {
    const { dispatch } = this.props
    dispatch(User.fetch({ query: data }))
  }

  handleSearchReset = () => {
    const { dispatch } = this.props
    dispatch(reset('userSearch'))
    dispatch(User.fetch())
  }

  render() {
    const {
      users,
      enumValues,
      usersById,
      rolesById,
    } = this.props

    return (
      <div>
        <Helmet title="员工管理" />

        <Link className="ant-btn ant-btn-primary ant-btn-lg" to="/users/new">新增员工</Link>

        <SearchBar
          enumValues={enumValues}
          handleSearch={this.handleSearch}
          handleSearchReset={this.handleSearchReset}
        />

        <List
          users={users}
          usersById={usersById}
          rolesById={rolesById}
          handleSwitch={this.handleSwitch}
          handleDestroy={this.handleDestroy}
        />
      </div>
    )
  }
}
