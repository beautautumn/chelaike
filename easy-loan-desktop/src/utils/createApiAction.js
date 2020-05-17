import { createAction } from 'redux-actions'

export default function createApiAction(name) {
  const action = ['request', 'success', 'failure'].reduce((acc, cur) => {
    const type = `${name}/${cur}`
    acc[cur] = createAction(type)
    return acc
  }, {})

  const request = createAction(`${name}/request`)

  return Object.assign(request, action)
}
