import { LOCATION_CHANGE } from 'react-router-redux'

export default () => next => action => {
  if (action.type === LOCATION_CHANGE && window._hmt) { // eslint-disable-line
    setTimeout(() => {
      const { pathname } = action.payload
      window._hmt.push(['_trackPageview', pathname]) // eslint-disable-line
    })
  }
  return next(action)
}
