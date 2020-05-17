import { create, update } from '../mortgageCompanies'
import { error } from '../concerns'

const reducer = error('mortgageCompany', [create, update])

export default reducer
