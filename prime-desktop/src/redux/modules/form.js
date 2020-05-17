import { reducer as formReducer } from 'redux-form'
import user from './form/user'
import role from './form/role'
import car from './form/car'
import prepareRecord from './form/prepareRecord'
import channel from './form/channel'
import shop from './form/shop'
import intentionLevel from './form/intentionLevel'
import warranty from './form/warranty'
import insuranceCompany from './form/insuranceCompany'
import mortgageCompany from './form/mortgageCompany'
import cooperationCompany from './form/cooperationCompany'
import password from './form/password'
import intention from './form/intention'
import { normalize as carPriceNormalize } from './form/carPrice'

export default formReducer.plugin({
  user,
  role,
  car,
  prepareRecord,
  channel,
  shop,
  warranty,
  insuranceCompany,
  mortgageCompany,
  cooperationCompany,
  password,
  intention,
  intentionLevel
}).normalize({
  carPrice: carPriceNormalize
})
