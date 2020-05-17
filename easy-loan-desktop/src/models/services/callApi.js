import 'isomorphic-fetch'
import { normalize } from 'normalizr'
import qs from 'qs'
import config from '../../config'
import { getToken } from '../services/auth'
import isArray from 'lodash/isArray'
import isNumber from 'lodash/isNumber'

export default function callApi(endpoint, options = {}) {
  const { query, body, schema, ...init } = options
  const token = getToken()
  let url = [config.serverUrl, config.basePath, endpoint].join('')

  if (query) {
    url += qs.stringify(query, { addQueryPrefix: true })
  }
  if (body) {
    init.body = JSON.stringify(body)
  }
  const headers = { 'Content-Type': 'application/json' }
  if (token) headers.AutobotsToken = token
  init.headers = { ...init.headers, ...headers }

  return fetch(url, init)
    .then(response => response.json().then(json => ({json, response})))
    .then(({response, json}) => {
      if (!response.ok || (json.code && json.code !== 200)) {
        const error = {
          data: json,
          code: response.ok ? json.code : response.status,
          error: true,
        }
        return Promise.reject(error)
      }

      const content = json.data && isArray(json.data.content) ? json.data.content : json.data
      const data = schema ? normalize(content, schema) : content
      const meta = json.meta || {}
      if (json.data && isNumber(json.data.totalElements)) {
        meta.total = json.data.totalElements
      }
      return { data, meta }
    })
    .then(
      response => ({ response }),
      error => ({ error })
    )
}
