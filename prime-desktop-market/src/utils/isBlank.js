import isEmpty from 'lodash/isEmpty'
import isNaN from 'lodash/isNaN'

export default (object) => {
  if (typeof object === 'number') {
    return isNaN(object)
  }
  return isEmpty(object)
}
