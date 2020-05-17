import { create, update } from '../warranties'
import { error } from '../concerns'

const reducer = error('warranty', [create, update])

export default reducer
