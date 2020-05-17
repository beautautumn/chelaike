import { createSelector } from 'reselect'

/**
 * Result functions
 */
function selectEntities(entities, ids) {
  return ids.reduce((accumulator, id) => ([...accumulator, entities[id]]), [])
}

function selectEntity(entities, id) {
  return entities ? entities[id] : null
}

const cachedVisibleEntitiesSelectors = {}
const cachedEntitySelectors = {}

export function visibleEntitiesSelector(entityName) {
  if (cachedVisibleEntitiesSelectors[entityName]) {
    return cachedVisibleEntitiesSelectors[entityName]
  }

  const entitiesSelector = (state) => state.entities[entityName]
  const idsSelector = (state, ids) => ids || state[entityName].ids

  cachedVisibleEntitiesSelectors[entityName] = createSelector(
    entitiesSelector,
    idsSelector,
    (entities, ids) => selectEntities(entities, ids)
  )
  return cachedVisibleEntitiesSelectors[entityName]
}

export function entitySelector(entityName) {
  if (cachedEntitySelectors[entityName]) {
    return cachedEntitySelectors[entityName]
  }

  const entitiesSelector = (state) => state.entities[entityName]
  const idSelector = (state, id) => id

  cachedEntitySelectors[entityName] = createSelector(
    entitiesSelector,
    idSelector,
    (entities, id) => selectEntity(entities, id)
  )

  return cachedEntitySelectors[entityName]
}
