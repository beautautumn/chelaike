import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'feeble/saga/effects'
import { goBack } from 'react-router-redux'
import { crud } from './concerns'
import Schemas from 'config/schemas'
import Entity from './entity'
import Notification from './notification'

const models = []

export default function factory(namespace) {
  if (models[namespace]) {
    return models[namespace]
  }

  const model = feeble.model({
    namespace,
    state: {
      ids: [],
      fetching: false,
      fetched: false,
      saving: false,
    },
  })

  models[namespace] = model

  model.apiAction('create', user => ({
    method: 'post',
    endpoint: '/users',
    body: { user },
    schema: Schemas.USER,
  }))

  model.apiAction('fetch', query => ({
    method: 'get',
    endpoint: '/users',
    query: { ...query, perPage: 1000 },
    schema: Schemas.USER_ARRAY,
  }))

  model.apiAction('fetchOne', id => ({
    method: 'get',
    endpoint: `/users/${id}`,
    schema: Schemas.USER,
  }))

  model.apiAction('update', user => ({
    method: 'put',
    endpoint: `/users/${user.id}`,
    body: { user },
    schema: Schemas.USER,
  }))

  model.apiAction('switchState', user => ({
    method: 'put',
    endpoint: `/users/${user.id}`,
    body: { user },
    schema: Schemas.USER,
  }))

  model.apiAction('destroy', id => ({
    method: 'del',
    endpoint: `/users/${id}`,
    schema: Schemas.USER,
  }))

  model.reducer(crud(model))

  model.selector('list',
    () => Entity.getState().user,
    () => model.getState().ids,
    (entities, ids) => ids.map(id => entities[id])
  )

  model.selector('one',
    () => Entity.getState().user,
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

  return model
}
