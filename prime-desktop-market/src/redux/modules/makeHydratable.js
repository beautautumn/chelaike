// https://github.com/reactjs/redux/pull/658
export const HYDRATE_STATE = 'HYDRATE_STATE'

export default function makeHydratable(reducer) {
  function hydratedReducer(state, action) {
    switch (action.type) {
      case HYDRATE_STATE:
        return reducer(action.payload, action)
      default:
        return reducer(state, action)
    }
  }

  return hydratedReducer
}

export function replaceState(state) {
  return {
    type: HYDRATE_STATE,
    payload: state
  }
}
