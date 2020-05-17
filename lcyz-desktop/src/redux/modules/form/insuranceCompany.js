import { create, update } from '../insuranceCompanies'
import { error } from '../concerns'

const reducer = error('insuranceCompany', [create, update])

export default reducer
