import { create, update } from '../shops'
import { error } from '../concerns'

const reducer = error('authorityRole', [create, update])

export default reducer
