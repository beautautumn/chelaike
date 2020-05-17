import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { push, goBack } from 'react-router-redux'
import { fetchOne, create, update } from 'redux/modules/roles'
import { show as showNotification } from 'redux/modules/notification'
import { entitySelector } from 'redux/selectors/entities'
import Form from './Form/Form'
import { connectData } from 'decorators'

function fetchData(getState, dispatch, location, params) {
  if (!getState().roles.fetched && params.id) {
    return dispatch(fetchOne(params.id))
  }
}

@connectData(fetchData)
@connect(
  (state, { params }) => ({
    role: entitySelector('roles')(state, params.id),
    saved: state.roles.saved,
    saving: state.roles.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
      push,
      goBack,
    }, dispatch)
  })
)
export default class EditPage extends Component {
  static propTypes = {
    params: PropTypes.object.isRequired,
    role: PropTypes.object,
    showNotification: PropTypes.func.isRequired,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    push: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool,
    goBack: PropTypes.func.isRequired,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.push('/roles')
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleSubmit = (data) => {
    if (this.props.params && this.props.params.id) {
      this.props.update(data)
    } else {
      this.props.create(data)
    }
  }

  handleCancel = () => {
    this.props.goBack()
  }

  render() {
    const { role, saving } = this.props

    return (
      <Form
        initialValues={role}
        onSubmit={this.handleSubmit}
        handleCancel={this.handleCancel}
        saving={saving}
      />
    )
  }
}
