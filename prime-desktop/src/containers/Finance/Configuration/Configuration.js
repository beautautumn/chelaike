import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { connectData } from 'decorators'
import { fetch, update } from 'redux/modules/finance/configuration'
import { show as showNotification } from 'redux/modules/notification'
import Form from './Form'

function fetchData(getState, dispatch) {
  return dispatch(fetch())
}

@connectData(fetchData)
@connect(
  (state) => ({
    configuration: state.financeConfiguration.data,
  }),
  dispatch => (
    bindActionCreators({
      update,
      showNotification,
    }, dispatch)
  )
)
export default class Configuration extends Component {
  static propTypes = {
    configuration: PropTypes.object.isRequired,
    update: PropTypes.func.isRequired,
  }

  handleSubmit = (data) => {
    const { saving, update, showNotification } = this.props
    if (saving) return

    update(data).then((response) => {
      showNotification({
        type: response.error ? 'error' : 'success',
        message: response.error ? response.error.message : '保存成功'
      })
    })
  }

  render() {
    const { configuration } = this.props

    return (
      <Form initialValues={configuration} onSubmit={this.handleSubmit} />
    )
  }
}
