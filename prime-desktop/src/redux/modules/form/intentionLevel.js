import { create, update } from '../intentionLevels'
import { error } from '../concerns'

const reducer = error('intentionLevel', [create, update])

export default reducer
