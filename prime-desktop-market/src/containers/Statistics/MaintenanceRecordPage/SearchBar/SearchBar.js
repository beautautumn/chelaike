import React, { Component, PropTypes } from 'react'
import SearchBarForm from './SearchBarForm'

export default class SearchBar extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired
  }

  handleSubmit = data => {
    const { fetch, fetchParams } = this.props
    fetch({ ...fetchParams, query: data, page: 1 }, true)
  }

  render() {
    return (
      <SearchBarForm
        onSubmit={this.handleSubmit}
      />
    )
  }
}
