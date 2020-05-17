/**
 * 根据 action 的 key 动态生产状态子节点
 */
export default function dynamic(reducer) {
  return (state, action) => {
    const key = action.meta ? action.meta.key : undefined
    if (key) {
      return {
        ...state,
        [key]: reducer(state[key], action),
      }
    }
    return reducer(state, action)
  }
}
