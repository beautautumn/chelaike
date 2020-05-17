import React, { Component, PropTypes } from 'react'
import styles from './Layout.scss'
import cx from 'classnames'

export default class Layout extends Component {
  static propTypes = {
    children: PropTypes.element,
  }

  render() {
    const { children } = this.props

    return (
      <div className={cx(styles.password, 'ui middle aligned center aligned grid')}>
        <div className="column">
          {children}
        </div>
      </div>
    )
  }
}
