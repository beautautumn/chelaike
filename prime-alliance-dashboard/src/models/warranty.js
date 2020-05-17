import feeble from 'feeble'
import { crud } from './concerns'
import Schemas from 'config/schemas'
import Entity from './entity'

const model = feeble.model({
  namespace: 'warranty',
  state: {
    ids: [],
    fetching: false,
    fetched: false,
    saving: false,
  },
})

model.apiAction('create', warranty => ({
  method: 'post',
  endpoint: '/warranties',
  payload: { data: { warranty } },
  schema: Schemas.WARRANTY,
}))

model.apiAction('fetch', id => ({
  method: 'get',
  endpoint: `/companies/${id}/warranties`,
  schema: Schemas.WARRANTY_ARRAY,
}))

model.apiAction('update', warranty => ({
  method: 'put',
  endpoint: `/warranties/${warranty.id}`,
  payload: { data: { warranty } },
  schema: Schemas.WARRANTY,
}))

model.apiAction('destroy', id => ({
  method: 'del',
  endpoint: `/warranties/${id}`,
  schema: Schemas.WARRANTY,
}))

model.reducer(crud(model))

model.selector('list',
  () => Entity.getState().warranty,
  () => model.getState().ids,
  (entities, ids) => ids.map(id => entities[id])
)

export default model
