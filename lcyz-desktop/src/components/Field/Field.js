import React from 'react'
import cx from 'classnames'

export default ({ className, touched, valid, error, children }) => (
  <div className={cx(className, { error: touched && !valid })}>
    {children}
    {
      touched && !valid && (
        <div className="ui pointing red basic label">
          {error}
        </div>
      )
    }
  </div>
)
