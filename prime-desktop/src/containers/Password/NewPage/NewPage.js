import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { reset } from 'redux/modules/password'
import { bindActionCreators } from 'redux'
import Form from './Form'

@connect(
  (state) => ({
    has_reset: state.password.reset,
  }),
  dispatch => ({
    ...bindActionCreators({ reset }, dispatch)
  })
)
export default class NewPage extends Component {
  static propTypes = {
    has_reset: PropTypes.bool,
    reset: PropTypes.func.isRequired,
    history: PropTypes.object,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.has_reset && nextProps.has_reset) {
      this.props.history.pushState(null, '/login')
    }
  }

  handleSubmit = (data) => {
    this.props.reset(data)
  }

  render() {
    return (
      <div>
        <h2 className="ui teal image header">
          <div className="content">
            重置密码
          </div>
        </h2>
        <Form
          onSubmit={this.handleSubmit}
        />
      </div>
    )
  }
}
