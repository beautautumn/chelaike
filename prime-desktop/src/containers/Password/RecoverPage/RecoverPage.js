import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { push } from 'react-router-redux'
import Form from './Form'

@connect(
  null,
  dispatch => ({
    ...bindActionCreators({ push }, dispatch)
  })
)
export default class RecoverPage extends Component {
  static propTypes = {
    push: PropTypes.func.isRequired
  }

  handleNext = () => {
    this.props.push('/passwords/new')
  }

  render() {
    return (
      <div>
        <h2 className="ui teal image header">
          <div className="content">
            找回密码
          </div>
        </h2>
        <Form
          handleNext={this.handleNext}
        />
      </div>
    )
  }
}
