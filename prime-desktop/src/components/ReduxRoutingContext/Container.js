import React, { Component, PropTypes } from 'react'

export default class Container extends Component {
  static propTypes = {
    Component: PropTypes.func.isRequired,
    routerProps: PropTypes.object.isRequired
  }

  static contextTypes = {
    reduxContext: PropTypes.object.isRequired
  }

  render() {
    const { Component, routerProps } = this.props
    const { loading } = this.context.reduxContext

    return (
      <Component
        {...routerProps}
        loading={loading}
      />
    )
  }
}
