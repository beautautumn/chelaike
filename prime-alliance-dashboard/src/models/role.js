import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'feeble/saga/effects'
import { goBack } from 'react-router-redux'
import { crud } from './concerns'
import Schemas from 'config/schemas'
import Entity from './entity'
import Notification from './notification'

const model = feeble.model({
  namespace: 'role',
  state: {
    ids: [],
    fetching: false,
    fetched: false,
    saving: false,
    saved: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '/authority_roles',
  schema: Schemas.ROLE_ARRAY,
}))

model.apiAction('fetchOne', id => ({
  method: 'get',
  endpoint: `/authority_roles/${id}`,
  schema: Schemas.ROLE,
}))

model.apiAction('destroy', id => ({
  method: 'del',
  endpoint: `/authority_roles/${id}`,
  schema: Schemas.ROLE,
}))

model.apiAction('create', role => ({
  method: 'post',
  endpoint: '/authority_roles',
  body: { authority_role: role },
  schema: Schemas.ROLE,
}))

model.apiAction('update', role => ({
  method: 'put',
  endpoint: `/authority_roles/${role.id}`,
  body: { authority_role: role },
  schema: Schemas.ROLE,
}))

model.reducer(crud(model))

model.selector('list',
  () => Entity.getState().role,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

model.selector('one',
  () => Entity.getState().role,
  id => id,
  (entities, id) => (entities ? entities[id] : null)
)

function* watchSave() {
  const pattern = [
    model.create.success,
    model.update.success,
  ]
  yield* takeEvery(pattern, function* () {
    yield put(goBack())
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
