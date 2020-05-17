import React, { Component } from 'react'
import hoistStatics from 'hoist-non-react-statics'

let globalId = 1

/**
 * 自动生成 label 和 input 的 id
 * 必须放在其他修饰器的下面，不然组件更新时 group 没法被重置
 */
export default WrappedComponent => {
  class AutoId extends Component {
    constructor(props) {
      super(props)

      this.ids = {}
      this.group = 1
    }

    componentWillUpdate() {
      this.group = 1
    }

    generateId(ident) {
      if (!this.ids[ident]) {
        this.ids[ident] = ['autoId', ident, globalId++].join('-')
      }
      return this.ids[ident]
    }

    autoId = () => {
      this.group += 1
      return this.generateId(this.group - (this.group % 2))
    }

    render() {
      return <WrappedComponent {...this.props} autoId={this.autoId} />
    }
  }
  return hoistStatics(AutoId, WrappedComponent)
}
