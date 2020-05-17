import test from 'ava'
import feeble from 'feeble'
import crud from 'models/concerns/crud'

const model = feeble.model({
  namespace: 'test',
})

model.apiAction('create')
model.apiAction('fetch')
model.apiAction('update')
model.apiAction('destroy')

model.reducer(crud(model))

const reducer = model.getReducer()

test('create request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.create.request.getType() }
    ),
    { saving: true, saved: false }
  )
})

test('create success', t => {
  t.deepEqual(
    reducer(
      { ids: [2, 1] },
      { type: model.create.success.getType(), payload: { result: 3 } }
    ),
    { ids: [3, 2, 1], saving: false, saved: true }
  )
})

test('create error', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.create.error.getType() },
    ),
    { saving: false, saved: false }
  )
})

test('fetch request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.fetch.request.getType() }
    ),
    { fetching: true, fetched: false },
  )
})

test('fetch success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.fetch.success.getType(), payload: { result: [1, 2] } }
    ),
    { ids: [1, 2], fetching: false, fetched: true }
  )
})

test('update request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.update.request.getType() }
    ),
    { saving: true, saved: false }
  )
})

test('update success', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.update.success.getType() }
    ),
    { saving: false, saved: true }
  )
})

test('destroy request', t => {
  t.deepEqual(
    reducer(
      undefined,
      { type: model.destroy.request.getType() }
    ),
    { destroyed: false }
  )
})

test('destroy success', t => {
  t.deepEqual(
    reducer(
      { ids: [2, 1] },
      { type: model.destroy.success.getType(), payload: { result: 1 } }
    ),
    { ids: [2], destroyed: true }
  )
})
