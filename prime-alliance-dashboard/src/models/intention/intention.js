import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'redux-saga/effects'
import { hide } from 'redux-modal'
import { PAGE_SIZE } from 'config/constants'
import Schemas from 'config/schemas'
import Entity from '../entity'
import Notification from '../notification'
import { crud, pagination, query } from '../concerns'

const model = feeble.model({
  namespace: 'intention::intention',
  state: {
    ids: [],
    query: {},
    total: 0,
    fetching: false,
    fetched: false,
    saving: false,
    selectedIds: [],
  },
})

model.apiAction('fetch', query => ({
  method: 'get',
  query: { ...query, perPage: PAGE_SIZE },
  endpoint: '/intentions',
  schema: Schemas.INTENTION_ARRAY,
}), query => ({
  query,
}))

model.apiAction('fetchOne', id => ({
  method: 'get',
  endpoint: `/intentions/${id}`,
  schema: Schemas.INTENTION,
}))

model.apiAction('create', intention => ({
  method: 'post',
  body: { intention },
  endpoint: '/intentions',
  schema: Schemas.INTENTION,
}))

model.apiAction('update', intention => ({
  method: 'put',
  body: { intention },
  endpoint: `/intentions/${intention.id}`,
  schema: Schemas.INTENTION,
}))

model.apiAction('destroy', id => ({
  method: 'del',
  endpoint: `/intentions/${id}`,
  schema: Schemas.INTENTION,
}))

model.apiAction('assign', data => ({
  method: 'put',
  body: data,
  endpoint: '/intentions/batch_assign',
  schema: Schemas.INTENTION_ARRAY,
}))

model.action('check')

model.reducer(on => {
  on(model.check, (state, payload) => ({
    ...state,
    selectedIds: payload,
  }))
})

model.reducer(crud(model))
model.reducer(pagination(model.fetch))
model.reducer(query(model.fetch))

model.selector('list',
  () => Entity.getState().intention,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

model.selector('one',
  () => Entity.getState().intention,
  id => id,
  (entities, id) => (entities ? entities[id] : null)
)

function* watchSave() {
  const pattern = [
    model.create.success,
    model.update.success,
  ]
  yield* takeEvery(pattern, function* () {
    yield put(hide('intentionEdit'))
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

function* watchAssign() {
  yield* takeEvery(model.assign.success, function* () {
    yield put(hide('intentionAssign'))
    yield put(Notification.show({
      type: 'success',
      message: '分配成功',
    }))
  })
}

model.effect(function* () {
  yield [
    fork(watchSave),
    fork(watchDestroy),
    fork(watchAssign),
  ]
})

export default model
