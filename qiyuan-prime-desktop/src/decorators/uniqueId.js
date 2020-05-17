import React, { Component } from 'react'
import hoistStatics from 'hoist-non-react-statics'
import uniqueId from 'lodash/uniqueId'

/**
 * 给组件生成一个 id
 */
export default prefix => WrappedComponent => {
  class UniqueId extends Component {
    constructor(props) {
      super(props)

      this.uniqueId = uniqueId(prefix)
    }

    render() {
      return <WrappedComponent {...this.props} uniqueId={this.uniqueId} />
    }
  }

  return hoistStatics(UniqueId, WrappedComponent)
}
