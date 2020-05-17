import React, { Component, PropTypes } from 'react'
import { Progress } from 'antd'
import { Segment } from 'components'

export default class ProgressBar extends Component {
  static propTypes = {
    progress: PropTypes.number
  }

  render() {
    const { progress } = this.props

    return (
      <Segment>
        <div>导入进度</div>
        <Progress type="line" percent={progress} />
      </Segment>
    )
  }
}
