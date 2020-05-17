import { create, update } from '../intentions.js'
import { error } from '../concerns'

const reducer = error('intention', [create, update])

export default reducer
