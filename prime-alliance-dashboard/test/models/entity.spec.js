import test from 'ava'
import Entity from 'models/entity'

const reducer = Entity.getReducer()

test('handle actions with response entities', t => {
  const previousState = {
    cars: {
      1: { name: 'Audi', price: 9 },
      2: { name: 'BWM', price: 10 },
    },
  }
  const action = {
    payload: {
      entities: {
        cars: {
          2: { name: 'BWM', price: 11 },
          3: { name: 'Ford' },
          4: { name: 'Ferrari' },
        },
      },
    },
  }
  const expectedState = {
    cars: {
      1: { name: 'Audi', price: 9 },
      2: { name: 'BWM', price: 11 },
      3: { name: 'Ford' },
      4: { name: 'Ferrari' },
    },
  }

  t.deepEqual(
    reducer(previousState, action),
    expectedState
  )
})
