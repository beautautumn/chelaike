import React, { Component, PropTypes } from 'react'
import shallowEqual from 'react-redux/lib/utils/shallowEqual'
import hoistStatics from 'hoist-non-react-statics'
import omit from 'lodash/omit'
import get from 'lodash/get'

// 优化 form，减少渲染次数
export default function formOptimize(fields) {
  return WrappedComponent => {
    class FormOptimize extends Component {
      static propTypes = {
        fields: PropTypes.object.isRequired,
      }

      shouldComponentUpdate(nextProps) {
        let haveFieldsChanged = false
        let haveOtherPropsChanged = false

        for (const field of fields) {
          if (!shallowEqual(get(this.props.fields, field), get(nextProps.fields, field))) {
            haveFieldsChanged = true
            break
          }
        }

        const currentOtherProps = omit(this.props, 'fields')
        const nextOtherProps = omit(nextProps, 'fields')

        haveOtherPropsChanged = !shallowEqual(currentOtherProps, nextOtherProps)

        return haveFieldsChanged || haveOtherPropsChanged
      }

      render() {
        return <WrappedComponent {...this.props} />
      }
    }

    return hoistStatics(FormOptimize, WrappedComponent)
  }
}
