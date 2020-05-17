/**
 * 在指定 action 的时候自动重置状态
 *
 * 例子：
 *
 *   recycle(LOCATION_CHANGE, reducer)
 */
export default function recycle(actionTypes, reducer) {
  return (state, action) => {
    const actionTypesArray = Array.isArray(actionTypes) ? actionTypes : [actionTypes]
    if (~actionTypesArray.indexOf(action.type)) {
      return reducer(undefined, {})
    }
    return reducer(state, action)
  }
}

