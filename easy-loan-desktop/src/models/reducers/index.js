import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import auth from './auth';
import profile from './profile';
import loans from './loan';
import transfers from './transfer';
import stores from './stores';
import repayments from './repayment';
import companies from './company';
import series from './series';
import users from './user';
import roles from './role';
import layout from './layout';
import inventories from './inventory';
import founderInventories from './founderInventory';
import inventoryDetails from './inventoryDetail';
import founderInventoryDetails from './founderInventoryDetail';
import mapValues from 'lodash/mapValues';

function entities(state = {}, action) {
  if (action.payload && action.payload.entities) {
    return {
      ...state,
      ...mapValues(action.payload.entities, (entities, key) => ({
        ...state[key],
        ...mapValues(entities, (entity, id) => {
          if (state[key]) {
            return { ...state[key][id], ...entity };
          }
          return entity;
        })
      }))
    };
  }
  return state;
}

export default combineReducers({
  router: routerReducer,
  entities,
  auth,
  profile,
  loans,
  transfers,
  repayments,
  companies,
  stores,
  inventories,
  inventoryDetails,
  users,
  roles,
  series,
  founderInventories,
  founderInventoryDetails,
  layout
});
