import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { goBack } from 'react-router-redux'
import userFactory from 'models/user'
import Role from 'models/role'
import { connectData } from 'decorators'
import Form from './Form'
import Helmet from 'react-helmet'

const User = userFactory('user::list')

function fetchData(getState, dispatch, location, params) {
  let promise
  if (params.id) {
    promise = dispatch(User.fetchOne(params.id))
  }
  return promise
}

@connectData(fetchData)
@connect(
  (_state, { params }) => ({
    user: User.select('one', params.id),
    saving: User.getState().saving,
    roles: Role.select('list'),
  })
)
export default class EditPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    user: PropTypes.object,
    roles: PropTypes.array.isRequired,
    saving: PropTypes.bool.isRequired,
  }

  componentWillMount() {
    const { dispatch } = this.props
    dispatch(Role.fetch())
  }

  handleSubmit = data => {
    const { dispatch, saving } = this.props
    if (saving) return
    if (data.id) {
      dispatch(User.update(data))
    } else {
      dispatch(User.create(data))
    }
  }

  handleCancel = () => {
    const { dispatch } = this.props
    dispatch(goBack())
  }

  render() {
    const { roles } = this.props
    let { user } = this.props

    if (user) {
      user.managerId = user.manager && user.manager.id
      user.authorityRoleIds = user.authorityRoles.map(role => role.id)
    } else {
      user = {
        state: 'enabled',
        authorityType: 'role',
        authorityRoleIds: [],
        authorities: [],
      }
    }

    return (
      <div>
        <Helmet title={user.id ? '编辑员工' : '新增员工'} />

        <Form
          initialValues={user}
          roles={roles}
          onSubmit={this.handleSubmit}
          handleCancel={this.handleCancel}
        />
      </div>
    )
  }
}
