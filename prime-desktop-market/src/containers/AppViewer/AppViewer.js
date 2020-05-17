import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { remberToken } from 'redux/modules/auth'

@connect(
  null,
  dispatch => bindActionCreators({ remberToken }, dispatch)
)
export default class AppViewer extends Component {
  componentDidMount() {
    const { token } = this.props.location.query
    if (token && token.startsWith('AutobotsAuth')) {
      this.props.remberToken(token)
    }
  }

  render() {
    return (
      <div>ok</div>
    )
  }
}
