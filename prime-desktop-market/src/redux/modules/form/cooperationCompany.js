import { create, update } from '../cooperationCompanies'
import { error } from '../concerns'

const reducer = error('cooperationCompany', [create, update])

export default reducer
