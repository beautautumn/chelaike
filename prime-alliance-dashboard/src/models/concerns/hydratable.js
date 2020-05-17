// https://github.com/reactjs/redux/pull/658
export const HYDRATE_STATE = 'HYDRATE_STATE'

export default function hydratable(reducer) {
  return (state, action) => {
    switch (action.type) {
      case HYDRATE_STATE:
        return reducer(action.state, action)
      default:
        return reducer(state, action)
    }
  }
}

export function replaceState(state) {
  return {
    type: HYDRATE_STATE,
    state,
  }
}
