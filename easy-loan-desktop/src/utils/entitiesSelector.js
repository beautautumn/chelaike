import { createSelector } from 'reselect'

const cachedEntitiesSelectors = {}

function selectEntities(entities, ids) {
  return ids.reduce((acc, id) => {
    if (entities[id]) acc.push(entities[id])
    return acc
  }, [])
}

export default function entitiesSelector(entityName) {
  if (!cachedEntitiesSelectors[entityName]) {
    const entitiesSelector = (state) => state.entities[entityName] || {}
    const idsSelector = (state, ids) => ids || state[entityName].ids

    cachedEntitiesSelectors[entityName] = createSelector(
      entitiesSelector,
      idsSelector,
      (entities, ids) => {
        return selectEntities(entities, ids)
      }
    )
  }
  return cachedEntitiesSelectors[entityName]
}

