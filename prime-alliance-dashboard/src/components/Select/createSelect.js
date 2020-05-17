import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import capitalize from 'lodash/capitalize'
import { Select } from '..'

/**
 * A factory function to create smart <Select>s
 */
export default function createSelect(name, { prompt, model }) {
  class SmartSelect extends Component {
    static propTypes = {
      dispatch: PropTypes.func.isRequired,
      items: PropTypes.array.isRequired,
      fetching: PropTypes.bool.isRequired,
      fetched: PropTypes.bool.isRequired,
      query: PropTypes.any,
    }

    componentWillMount() {
      const { dispatch, fetched, fetching, query } = this.props
      if (!fetched && !fetching) {
        dispatch(model.fetch(query))
      }
    }

    render() {
      return (
        <Select prompt={prompt} {...this.props} />
      )
    }
  }

  function mapStateToProps(_state) {
    return {
      items: model.select('list'),
      fetching: model.getState().fetching,
      fetched: model.getState().fetched,
    }
  }

  SmartSelect.displayName = `${capitalize(name)}Select`

  return connect(mapStateToProps)(SmartSelect)
}
