import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { put } from 'feeble/saga/effects'
import { hide } from 'redux-modal'
import Notification from 'models/notification'
import { dynamic } from '../concerns'
import Schemas from 'config/schemas'
import Entity from '../entity'
import values from 'lodash/values'

const model = feeble.model({
  namespace: 'pushHistory',
  state: {
    ids: [],
    saving: false,
  },
})

model.apiAction('fetch', intentionId => ({
  method: 'get',
  endpoint: `/intentions/${intentionId}/intention_push_histories`,
  schema: Schemas.INTENTION_PUSH_HISTORY_ARRAY,
}), intentionId => ({
  key: intentionId,
}))

model.apiAction('create', (intentionId, intentionPushHistory) => ({
  method: 'post',
  body: { intentionPushHistory },
  endpoint: `/intentions/${intentionId}/intention_push_histories`,
  schema: Schemas.INTENTION_PUSH_HISTORY,
}),
)

model.reducer(on => {
  on(model.fetch.success, (state, payload) => ({
    ...state,
    ids: payload.result,
  }))

  on(model.create.request, state => ({
    ...state,
    saving: true,
  }))

  on(model.create.success, state => ({
    ...state,
    saving: false,
  }))
}, dynamic)

model.selector('list',
  () => Entity.getState().intentionPushHistory,
  id => id,
  (entities, id) => (entities ? values(entities).reduce((pre, curr) => {
    if (curr.intentionId === id) pre.push(curr)
    return pre
  }, []) : [])
)

model.selector('orderList',
  () => Entity.getState().intentionPushHistory,
  id => (model.getState()[id] ? model.getState()[id].ids : []),
  (entities, ids) => ids.map(id => entities[id])
)

model.effect(function* () {
  yield* takeEvery(model.create.success, function* () {
    yield put(hide('intentionPush'))
    yield put(Notification.show({
      type: 'success',
      message: '保存成功',
    }))
  })
})

export default model
