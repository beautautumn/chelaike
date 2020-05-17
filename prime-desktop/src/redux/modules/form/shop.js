import { create, update } from '../shops'
import { error } from '../concerns'

const reducer = error('shop', [create, update])

export default reducer
