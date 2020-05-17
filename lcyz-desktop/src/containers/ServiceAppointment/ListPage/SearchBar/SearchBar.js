import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/serviceAppointments'
import SearchBarForm from './SearchBarForm'

@connect(
  state => ({
    fetchParams: state.serviceAppointments.fetchParams,
    enumValues: state.enumValues,
  }),
  { fetch }
)
export default class SearchBar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired
  }

  handleSubmit = data => {
    const { fetch, fetchParams } = this.props
    fetch({ ...fetchParams, query: data }, true)
  }

  render() {
    const { enumValues } = this.props

    return (
      <SearchBarForm
        onSubmit={this.handleSubmit}
        enumValues={enumValues}
      />
    )
  }
}
