import React, { Component, PropTypes } from 'react'
import styles from './Segment.scss'
import cx from 'classnames'

export default class Segment extends Component {
  static propTypes = {
    children: PropTypes.any,
    className: PropTypes.string
  }

  render() {
    const { children, className } = this.props

    return (
      <div className={cx(className, styles.segment)}>
        {children}
      </div>
    )
  }
}
