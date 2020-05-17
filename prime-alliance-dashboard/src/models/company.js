import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { put } from 'feeble/saga/effects'
import { hide } from 'redux-modal'
import { crud } from './concerns'
import Schemas from 'config/schemas'
import Entity from './entity'
import Notification from './notification'

const model = feeble.model({
  namespace: 'company',
  state: {
    ids: [],
    fetching: false,
    fetched: false,
  },
})

model.apiAction('fetch', () => ({
  method: 'get',
  endpoint: '/companies',
  schema: Schemas.COMPANY_ARRAY,
}))

model.apiAction('update', company => ({
  method: 'put',
  endpoint: `/companies/${company.id}`,
  body: { company },
  schema: Schemas.COMPANY,
}))

model.reducer(crud(model))

model.selector('list',
  () => Entity.getState().company,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

model.selector('one',
  () => Entity.getState().company,
  id => id,
  (entities, id) => (entities ? entities[id] : null)
)

model.effect(function* () {
  yield* takeEvery(model.update.success, function* () {
    yield put(hide('companyEdit'))
    yield put(Notification.show({
      type: 'success',
      message: '保存成功',
    }))
  })
})

export default model
