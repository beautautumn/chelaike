import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'feeble/saga/effects'
import { hide } from 'redux-modal'
import Notification from '../notification'
import { crud } from '../concerns'
import Schemas from 'config/schemas'
import Entity from '../entity'

const model = feeble.model({
  namespace: 'intentionLevel',
  state: {
    ids: [],
    fetching: false,
    fetched: false,
    saving: false,
  },
})

model.apiAction('create', intentionLevel => ({
  method: 'post',
  endpoint: '/intention_levels',
  body: { intentionLevel },
  schema: Schemas.INTENTION_LEVEL,
}))

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '/intention_levels',
  schema: Schemas.INTENTION_LEVEL_ARRAY,
}))

model.apiAction('update', intentionLevel => ({
  method: 'put',
  endpoint: `/intention_levels/${intentionLevel.id}`,
  body: { intentionLevel },
  schema: Schemas.INTENTION_LEVEL,
}))

model.apiAction('destroy', id => ({
  method: 'del',
  endpoint: `/intention_levels/${id}`,
  schema: Schemas.INTENTION_LEVEL,
}))

model.reducer(crud(model))

model.selector('list',
  () => Entity.getState().intentionLevel,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

model.selector('one',
  () => Entity.getState().intentionLevel,
  id => id,
  (entities, id) => (entities ? entities[id] : null)
)

function* watchSave() {
  const pattern = [
    model.create.success,
    model.update.success,
  ]
  yield* takeEvery(pattern, function* () {
    yield put(hide('levelEdit'))
    yield put(Notification.show({
      type: 'success',
      message: '保存成功',
    }))
  })
}

function* watchDestroy() {
  yield* takeEvery(model.destroy.success, function* () {
    yield put(Notification.show({
      type: 'success',
      message: '删除成功',
    }))
  })
}

model.effect(function* () {
  yield [
    fork(watchSave),
    fork(watchDestroy),
  ]
})

export default model
