import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { put } from 'feeble/saga/effects'
import Notification from 'models/notification'

const model = feeble.model({
  namespace: 'alliance',
  state: {
    alliance: {},
    saving: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '/alliances',
}))

model.apiAction('update', alliance => ({
  method: 'put',
  endpoint: '/alliances',
  body: { alliance },
}))

model.reducer(on => {
  on(model.fetch.success, (state, payload) => ({
    ...state,
    alliance: payload,
  }))

  on(model.update.request, (state) => ({
    ...state,
    saving: true,
  }))

  on(model.update.success, (state, payload) => ({
    ...state,
    alliance: payload,
    saving: false,
  }))

  on(model.update.error, (state) => ({
    ...state,
    saving: false,
  }))
})

model.effect(function* () {
  yield* takeEvery(model.update.success, function* () {
    yield put(Notification.show({
      type: 'success',
      message: '保存成功',
    }))
  })
})

export default model
