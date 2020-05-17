import React, { Component } from 'react'
import hoistStatics from 'hoist-non-react-statics'

/*
  Note:
    When this decorator is used, it MUST be the first (outermost) decorator.
    Otherwise, we cannot find and call the fetchData and fetchDataDeffered methods.
*/

export default function connectData(fetchData) {
  return function wrapWithFetchData(WrappedComponent) {
    class ConnectData extends Component {
      static fetchData = fetchData

      render() {
        return <WrappedComponent {...this.props} />
      }
    }

    return hoistStatics(ConnectData, WrappedComponent)
  }
}
