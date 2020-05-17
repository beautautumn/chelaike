import { createAction, createApiAction, createReducer } from 'rector/redux'
import Schemas from '../schemas'
import without from 'lodash/without'
import isUndefined from 'lodash/isUndefined'
import { PAGE_SIZE } from 'constants'

export const fetch = createApiAction('intentions/FETCH', (type, query) => ({
  method: 'get',
  endpoint: () => {
    if (type === 'following') {
      return '/intentions'
    } else if (type === 'recovery') {
      return '/intentions/recycle'
    }
    return '/customer_service_intentions'
  },
  schema: Schemas.INTENTION_ARRAY,
  query,
}), (type, query, reset) => ({
  query,
  reset,
}))

export const fetchOne = createApiAction('intentions/FETCH_ONE', id => ({
  method: 'get',
  endpoint: `/intentions/${id}`,
  schema: Schemas.INTENTION,
}))

export const create = createApiAction('intentions/CREATE', intention => ({
  method: 'post',
  endpoint: '/intentions',
  schema: Schemas.INTENTION,
  body: { intention },
}))

export const update = createApiAction('intentions/UPDATE', intention => ({
  method: 'put',
  endpoint: `/intentions/${intention.id}`,
  schema: Schemas.INTENTION,
  body: { intention },
}))

export const destroy = createApiAction('intentions/DESTROY', id => ({
  method: 'del',
  endpoint: `/customer_service_intentions/${id}`,
  schema: Schemas.INTENTION,
}))

export const changeCheckedIds = createAction('intentions/CHECKIDSCHANGE')

export const assign = createApiAction('intentions/ASSIGN', (type, body) => ({
  method: 'put',
  endpoint: type === 'following' ? '/intentions/batch_assign' :
    '/customer_service_intentions/batch_assign',
  schema: Schemas.INTENTION_ARRAY,
  body,
}))

export const batchDestroy = createApiAction('intentions/BATCH_DESTROY', ids => ({
  method: 'del',
  endpoint: '/intentions/batch_destroy',
  body: { intentionIds: ids },
}))

export const batchImport = createApiAction('intentions/IMPORT', body => ({
  method: 'post',
  endpoint: '/intentions/import',
  body,
}))

export const recive = createApiAction('intentions/RECIVE', body => ({
  method: 'put',
  endpoint: '/intentions/recycle',
  body,
}))

const initialState = {
  ids: [],
  fetchParams: {
    page: 1,
    orderBy: 'desc',
    orderField: 'id',
    perPage: PAGE_SIZE,
  },
  total: 0,
  checkedIds: [],
  saving: false
}

const reducer = createReducer(on => {
  on(fetch.request, state => ({
    ...state,
    fetching: true,
    fetched: false
  }))

  on([fetch.success, fetchOne.success], (state, payload, meta) => {
    const fetchParams = (meta && meta.query) ? meta.query : state.fetchParams
    let ids = state.ids

    if (meta.reset) {
      ids = payload.result
    } else {
      if (Array.isArray(payload.result)) {
        ids = [...ids, ...payload.result]
      }
    }
    const end = payload.result.length < PAGE_SIZE
    const total =
      isUndefined(meta.total) ? state.total : meta.total

    return {
      ...state,
      ids,
      fetchParams,
      fetching: false,
      fetched: true,
      end,
      total
    }
  })

  const saveRequest = state => ({
    ...state,
    error: null,
    saving: true,
    saved: false,
  })
  on(create.request, saveRequest)
  on(update.request, saveRequest)

  on(create.success, (state, payload) => ({
    ...state,
    ids: [payload.result, ...state.ids],
    saving: false,
    saved: true
  }))

  on(update.success, state => ({
    ...state,
    saving: false,
    saved: true
  }))

  const saveError = (state, payload) => ({
    ...state,
    saving: false,
    saved: false,
    error: payload.message
  })
  on(create.error, saveError)
  on(update.error, saveError)

  on(destroy.request, state => ({
    ...state,
    destroyed: false
  }))

  on(destroy.success, (state, payload) => ({
    ...state,
    ids: without(state.ids, payload.result),
    destroyed: true
  }))

  on(changeCheckedIds, (state, payload) => ({
    ...state,
    checkedIds: [...payload]
  }))

  on(assign.request, state => ({
    ...state,
    saving: true,
    saved: false
  }))

  on(assign.success, state => ({
    ...state,
    saving: false,
    saved: true,
    checkedIds: []
  }))

  on(assign.error, state => ({
    ...state,
    saving: false,
    saved: false
  }))

  on(batchDestroy.success, (state, payload) => ({
    ...state,
    checkedIds: [],
    ids: without(state.ids, ...payload)
  }))

  on(batchImport.request, state => ({
    ...state,
    importing: true,
    imported: false,
  }))

  on(batchImport.success, state => ({
    ...state,
    importing: false,
    imported: true
  }))

  on(batchImport.error, (state, payload) => ({
    ...state,
    importing: false,
    imported: false,
    error: payload,
  }))

  on(recive.success, (state, payload) => ({
    ...state,
    checkedIds: [],
    ids: without(state.ids, ...payload)
  }))
}, initialState)

export default reducer
