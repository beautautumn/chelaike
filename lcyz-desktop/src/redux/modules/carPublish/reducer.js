import { combineReducers } from 'redux'
import { polymorphicReducer } from 'redux-polymorphic'
import profiles from './profiles'
import platforms from './platforms'
import selects from './selects'

export default combineReducers({
  profiles,
  platforms,
  selects: polymorphicReducer({
    yiche: selects,
    che168: selects,
    com58: selects,
    ganji: selects
  })
})
