import feeble from 'feeble'
import { reducer } from 'redux-modal'

const model = feeble.model({
  namespace: 'modal',
})

model.setReducer(reducer)

export default model
