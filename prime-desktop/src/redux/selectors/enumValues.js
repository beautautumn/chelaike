import { createSelector } from 'reselect'
import omit from 'lodash/omit'
import pick from 'lodash/pick'

const carStatesSelector = (state) => state.enumValues.car.state

export const visibleCarStatesSelector = createSelector(
  carStatesSelector,
  (carStates) => ({
    inHallCarStates: omit(carStates,
      'driven_back', 'sold', 'acquisition_refunded',
      'alliance_refunded', 'alliance_stocked_out'),
    stockOutCarStates: pick(carStates, 'driven_back', 'sold', 'acquisition_refunded')
  })
)
