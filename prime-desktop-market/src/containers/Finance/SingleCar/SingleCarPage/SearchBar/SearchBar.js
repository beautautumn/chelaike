import React, { Component, PropTypes } from 'react'
import SearchBarForm from './SearchBarForm'

export default class SearchBar extends Component {
  static propTypes = {
    query: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired
  }

  handleSubmit = data => {
    const { fetch, query } = this.props
    fetch({ ...query, query: data, page: 1 }, true)
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
