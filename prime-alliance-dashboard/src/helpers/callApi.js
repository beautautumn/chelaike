import superagent from 'superagent'
import { normalize } from 'normalizr'
import { camelizeKeys, decamelizeKeys } from 'humps'
import formurlencoded from 'form-urlencoded'
import { getToken } from 'models/auth'
import config from 'config'

function formatUrl(endpoint) {
  let basePath
  let requestPath
  if (endpoint.startsWith('~')) {
    basePath = ''
    requestPath = endpoint.replace('~', '')
  } else {
    basePath = config.basePath
    requestPath = endpoint
  }
  return [config.serverUrl, basePath, requestPath].join('')
}

function encodeBody(body) {
  return (body instanceof FormData ? body : decamelizeKeys(body))
}

function encodeQuery(query) {
  return formurlencoded(decamelizeKeys(query))
}

export default function callApi({ method, endpoint, query, body, schema, raw }) {
  const encodedBody = encodeBody(body)
  const encodedQuery = encodeQuery(query)
  const token = getToken()

  return new Promise((resolve, reject) => {
    const request = superagent[method](formatUrl(endpoint))

    if (token) { request.set('AutobotsToken', token) }
    if (encodedQuery) { request.query(encodedQuery) }
    if (encodedBody) { request.send(encodedBody) }

    request.end((error, { body, headers, status }) => {
      const camelizedBody = camelizeKeys(body)
      if (error) {
        return reject({ payload: camelizedBody || error, error: true, meta: { status, headers } })
      }
      if (raw) {
        return resolve({ payload: body.data })
      }
      const extractedData = schema ? normalize(camelizedBody.data, schema) : camelizedBody.data
      const meta = camelizeKeys(camelizedBody.meta) || {}
      if (headers['x-total']) {
        meta.total = +headers['x-total']
      }
      return resolve({ payload: extractedData, meta })
    })
  })
}
