import React, { Component, PropTypes } from 'react'
import { RouterContext } from 'react-router'
import Container from './Container'
import getDataDependencies from 'helpers/getDataDependencies'
import shallowEqual from 'react-redux/lib/utils/shallowEqual'
import last from 'lodash/last'

function locationsAreEqual(locA, locB) {
  return locA.pathname === locB.pathname && locA.search === locB.search
}

function componentsDiff(previous, next) {
  return next.reduce((diff, component) => {
    if (!~previous.indexOf(component)) {
      diff.push(component)
    }
    return diff
  }, [])
}

export default class ReduxRoutingContext extends Component {

  static propTypes = {
    components: PropTypes.array.isRequired,
    params: PropTypes.object.isRequired,
    location: PropTypes.object.isRequired,
    store: PropTypes.object.isRequired,
    render: PropTypes.func,
  }

  static childContextTypes = {
    reduxContext: PropTypes.object,
  }

  static defaultProps = {
    render(props) {
      return <RouterContext {...props} />
    },
  }

  constructor(props, context) {
    super(props, context)

    this.state = {
      loading: false,
      loaded: null,
      prevProps: null,
    }
  }

  getChildContext() {
    const { loading } = this.state
    return {
      reduxContext: {
        loading,
      },
    }
  }

  componentDidMount() {
    const { components, location, params, store } = this.props
    this.loadData(components, location, params, store)
  }

  componentWillReceiveProps(nextProps) {
    if (locationsAreEqual(this.props.location, nextProps.location)) {
      return
    }

    const currentComponents = this.props.components
    const nextComponents = nextProps.components
    let components = componentsDiff(currentComponents, nextComponents)

    if (components.length === 0) {
      const sameComponents = shallowEqual(currentComponents, nextComponents)
      if (sameComponents) {
        const paramsChanged = !shallowEqual(this.props.params, nextProps.params)
        if (paramsChanged) {
          components = [last(nextComponents)]
        }
      }
    }
    const { location, params, store } = nextProps

    if (components.length > 0) {
      this.loadData(components, location, params, store)
    }
  }

  componentWillUnmount() {
    this.unmounted = true
  }

  createElement(Component, props) {
    return (
      <Container Component={Component} routerProps={props} />
    )
  }

  doTransition() {
    if (!this.unmounted) {
      this.setState({
        loading: false,
        loaded: true,
        prevProps: null,
      })
    }
  }

  loadData(components, location, params, store) {
    this.setState({
      loading: true,
      prevProps: this.props,
    })

    const { getState, dispatch } = store
    const dependencies = getDataDependencies(components, getState, dispatch, location, params)

    return Promise.all(dependencies)
    .then(() => {
      this.doTransition()
    })
    .catch(error => {
      if (process.env.NODE_ENV !== 'production') {
        throw error
      }
      this.doTransition()
    })
  }

  render() {
    const { loading, loaded, prevProps } = this.state
    if (!loaded) {
      return null
    }
    const props = loading ? prevProps : this.props
    return this.props.render({ ...props, createElement: this.createElement })
  }
}
