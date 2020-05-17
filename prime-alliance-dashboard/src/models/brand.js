import feeble from 'feeble'

const models = []

export default function factory(namespace) {
  if (models[namespace]) {
    return models[namespace]
  }

  const model = feeble.model({
    namespace,
    state: {
      data: [],
      fetching: false,
      fetched: false,
    },
  })

  models[namespace] = model

  model.apiAction('fetch', () => ({
    method: 'get',
    endpoint: '~/api/v1/brands',
  }))

  model.reducer(on => {
    on(model.fetch.request, state => ({
      ...state,
      fetching: true,
    }))

    on(model.fetch.success, (state, payload) => ({
      ...state,
      data: payload,
      fetching: false,
      fetched: true,
    }))
  })

  return model
}

