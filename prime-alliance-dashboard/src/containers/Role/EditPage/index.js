import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { goBack } from 'react-router-redux'
import Role from 'models/role'
import Form from './Form'
import { connectData } from 'decorators'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch, location, params) {
  let promise
  if (!Role.getState().fetched && params.id) {
    promise = dispatch(Role.fetchOne(params.id))
  }
  return promise
}

@connectData(fetchData)
@connect(
  (_state, { params }) => ({
    role: Role.select('one', params.id),
    saving: Role.getState().saving,
  })
)
export default class EditPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    params: PropTypes.object.isRequired,
    role: PropTypes.object,
    saving: PropTypes.bool.isRequired,
  }

  handleSubmit = data => {
    const { dispatch, saving, params } = this.props
    if (saving) return
    if (params && params.id) {
      dispatch(Role.update(data))
    } else {
      dispatch(Role.create(data))
    }
  }

  handleCancel = () => {
    const { dispatch } = this.props
    dispatch(goBack())
  }

  render() {
    const role = this.props.role || {}

    if (!role.id) {
      role.authorities = []
    }

    return (
      <div>
        <Helmet title={role.id ? '编辑角色' : '新增角色'} />

        <Form
          initialValues={role}
          onSubmit={this.handleSubmit}
          handleCancel={this.handleCancel}
        />
      </div>
    )
  }
}
