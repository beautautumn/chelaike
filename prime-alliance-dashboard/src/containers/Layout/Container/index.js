import React, { PropTypes } from 'react'
import styles from './style.scss'

export default function Container({ children }) {
  return (
    <div className={styles.container}>
      {children}
    </div>
  )
}

Container.propTypes = {
  children: PropTypes.object.isRequired,
}
