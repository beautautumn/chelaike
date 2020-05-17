import React, { Component, PropTypes } from 'react'
import hoistStatics from 'hoist-non-react-statics'

/*
 * 提交失败时自动 focus 到有错误的 field
 */
export default WrappedComponent => {
  class ErrorFocus extends Component {
    static propTypes = {
      _submitFailed: PropTypes.bool
    }

    componentDidUpdate(nextProps) {
      if (!this.props._submitFailed && nextProps._submitFailed) { // eslint-disable-line
        const errorField = document.querySelector('.field.error')
        if (errorField) {
          const inputs = errorField.getElementsByTagName('input')
          for (const input of inputs) {
            if (input.type !== 'hidden') {
              input.focus()
              return
            }
          }
        }
      }
    }

    render() {
      return <WrappedComponent {...this.props} />
    }
  }
  return hoistStatics(ErrorFocus, WrappedComponent)
}
