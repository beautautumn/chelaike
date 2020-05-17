import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import capitalize from 'lodash/capitalize'
import Select from './Select'

/**
 * A factory function to create smart <Select>s
 */
export default function createSelect(name, { prompt, fetch }) {
  class SmartSelect extends Component {
    static displayName = `${capitalize(name)}Select`

    static propTypes = {
      items: PropTypes.array.isRequired,
      fetching: PropTypes.bool.isRequired,
      fetched: PropTypes.bool.isRequired,
      fetch: PropTypes.func.isRequired
    }

    componentWillMount() {
      if (!this.props.fetched && !this.props.fetching) {
        this.props.fetch()
      }
    }

    render() {
      return (
        <Select prompt={prompt} {...this.props} />
      )
    }
  }

  function mapStateToProps(state) {
    return {
      items: visibleEntitiesSelector(name)(state),
      fetching: state[name].fetching,
      fetched: state[name].fetched
    }
  }

  function mapDispatchToProps(dispatch) {
    return {
      ...bindActionCreators({ fetch }, dispatch)
    }
  }

  return connect(mapStateToProps, mapDispatchToProps)(SmartSelect)
}
