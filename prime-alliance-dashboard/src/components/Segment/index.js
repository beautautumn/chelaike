import React, { PropTypes } from 'react'
import cx from 'classnames'
import styles from './style.scss'

export default function Segment({ children, className }) {
  return (
    <div className={cx(className, styles.segment)}>
      {children}
    </div>
  )
}

Segment.propTypes = {
  children: PropTypes.any,
  className: PropTypes.string,
}
