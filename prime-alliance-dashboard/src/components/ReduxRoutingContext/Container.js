import React, { PropTypes } from 'react'

export default function Container({ Component, routerProps }, { reduxContext: { loading } }) {
  return (
    <Component
      {...routerProps}
      loading={loading}
    />
  )
}

Container.propTypes = {
  Component: PropTypes.func.isRequired,
  routerProps: PropTypes.object.isRequired,
}


Container.contextTypes = {
  reduxContext: PropTypes.object.isRequired,
}
