import React, { Component, PropTypes } from 'react'
import { Progress } from 'antd'

export default class CompleteProgress extends Component {
  static propTypes = {
    finished: PropTypes.number,
    total: PropTypes.number
  }

  render() {
    const { finished, total } = this.props
    const percentage = finished / total * 100
    const status = percentage < 100 ? 'exception' : 'normal'

    return <Progress type="line" percent={percentage} status={status} />
  }
}
