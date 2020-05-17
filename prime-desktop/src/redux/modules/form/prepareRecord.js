import { CHANGE } from 'redux-form/lib/actionTypes'

export default (state, action) => {
  switch (action.type) {
    case CHANGE: {
      if (action.form !== 'prepareRecord') {
        return state
      }
      if (action.field !== 'prepareItemsAttributes') {
        return state
      }
      const totalAmountYuan = state.prepareItemsAttributes.value.reduce((accumulator, item) => {
        if (!item._destroy) { // eslint-disable-line
          return accumulator + Number.parseFloat(item.amountYuan)
        }
        return accumulator
      }, 0)
      return {
        ...state,
        totalAmountYuan: {
          ...state.totalAmountYuan,
          value: totalAmountYuan
        }
      }
    }
    default:
      return state
  }
}
