import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'feeble/saga/effects'
import { hide } from 'redux-modal'
import Notification from './notification'
import { crud } from './concerns'
import Schemas from 'config/schemas'
import Entity from './entity'

const model = feeble.model({
  namespace: 'channel',
  state: {
    ids: [],
    fetching: false,
    fetched: false,
    saving: false,
  },
})

model.apiAction('create', channel => ({
  method: 'post',
  endpoint: '/channels',
  body: { channel },
  schema: Schemas.CHANNEL,
}))

model.apiAction('fetch', companyId => ({
  method: 'get',
  endpoint: () => (companyId ? `/companies/${companyId}/channels` : '/channels'),
  schema: Schemas.CHANNEL_ARRAY,
}))

model.apiAction('update', channel => ({
  method: 'put',
  endpoint: `/channels/${channel.id}`,
  body: { channel },
  schema: Schemas.CHANNEL,
}))

model.apiAction('destroy', id => ({
  method: 'del',
  endpoint: `/channels/${id}`,
  schema: Schemas.CHANNEL,
}))

model.reducer(crud(model))

model.selector('list',
  () => Entity.getState().channel,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

model.selector('one',
  () => Entity.getState().channel,
  id => id,
  (entities, id) => (entities ? entities[id] : null)
)

function* watchSave() {
  const pattern = [
    model.create.success,
    model.update.success,
  ]
  yield* takeEvery(pattern, function* () {
    yield put(hide('channelEdit'))
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
