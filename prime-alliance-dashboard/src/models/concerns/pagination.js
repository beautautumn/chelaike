import isUndefined from 'lodash/isUndefined'

export default function pagination(fetch) {
  return on => {
    on(fetch.success, (state, payload, meta) => ({
      ...state,
      total: isUndefined(meta.total) ? state.total : meta.total,
    }))
  }
}
