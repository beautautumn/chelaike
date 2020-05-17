import React, { PropTypes } from 'react'
import styles from './style.scss'

export default function FormActions({ children }) {
  return (
    <div className={styles.formActions}>{children}</div>
  )
}

FormActions.propTypes = {
  children: PropTypes.any.isRequired,
}
