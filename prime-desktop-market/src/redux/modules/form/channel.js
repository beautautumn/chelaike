import { create, update } from '../channels'
import { error } from '../concerns'

const reducer = error('channel', [create, update])

export default reducer
