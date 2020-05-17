import { createReducer } from 'rector/redux'
import mapValues from 'lodash/mapValues'
import mapKeys from 'lodash/mapKeys'
import { signup } from '../auth'

const reducer = createReducer(on => {
  on(signup.error, (state, payload) => {
    const userFormValues = mapValues(payload.errors.user, (errors, field) => ({
      ...state[`user.${field}`],
      submitError: errors[0].replace('用户', '')
    }))
    const userForm = mapKeys(userFormValues, (_value, key) => (`user.${key}`))

    const companyFormValues = mapValues(payload.errors.company, (errors, field) => ({
      ...state[`company.${field}`],
      submitError: errors[0].replace('公司', '')
    }))
    const companyForm = mapKeys(companyFormValues, (_value, key) => (`company.${key}`))

    return {
      ...state,
      ...userForm,
      ...companyForm,
    }
  })
})

export default reducer
