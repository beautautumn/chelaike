import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { call } from 'feeble/saga/effects'
import { notification } from 'antd'

const model = feeble.model({
  namespace: 'notification',
  state: null,
})

model.action('show')

model.effect(function* () {
  yield* takeEvery(model.show, function* ({ payload }) {
    yield call(notification[payload.type], { ...payload, duration: 4.5 })
  })
})

export default model
