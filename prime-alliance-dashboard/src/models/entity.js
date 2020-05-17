import feeble from 'feeble'
import mapValues from 'lodash/mapValues'

const model = feeble.model({
  namespace: 'entity',
  state: {},
})

model.reducer(on => {
  on(action => action && action.payload && action.payload.entities, (state, payload) => ({
    ...state,
    ...(mapValues(payload.entities, (entities, key) => ({
      ...state[key],
      ...mapValues(entities, (entity, id) => {
        if (state[key]) {
          return { ...state[key][id], ...entity }
        }
        return entity
      }),
    }))),
  }))
})

export default model
