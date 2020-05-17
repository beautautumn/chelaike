const isEmpty = value => value === undefined || value === null || value === ''
const join =
  (rules) => (value, data) => rules.map(rule => rule(value, data)).filter(error => !!error)[0]

export function email(value) {
  // Let's not start a debate on email regex. This is just for an example app!
  if (!isEmpty(value) && !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(value)) {
    return 'Invalid email address'
  }
  return null
}

export function required(value) {
  if (isEmpty(value)) {
    return '不能为空'
  }
  return null
}

export function ltTenThousand(value) {
  if (value && value > 10000) {
    return '输入值不能大于一亿元'
  }
  return null
}

export function minLength(min) {
  return value => {
    if (!isEmpty(value) && value.length < min) {
      return `不能少于${min}位`
    }
    return null
  }
}

export function maxLength(max) {
  return value => {
    if (!isEmpty(value) && value.length > max) {
      return `不能多于${max}位`
    }
    return null
  }
}

export function integer(value) {
  if (!Number.isInteger(Number(value))) {
    return 'Must be an integer'
  }
  return null
}

export function oneOf(enumeration) {
  return value => {
    if (!~enumeration.indexOf(value)) {
      return `Must be one of: ${enumeration.join(', ')}`
    }
    return null
  }
}

export function createValidator(rules) {
  return (data = {}) => {
    const errors = {}
    Object.keys(rules).forEach((key) => {
      // concat enables both functions and arrays of functions
      const rule = join([].concat(rules[key]))
      const error = rule(data[key], data)
      if (error) {
        errors[key] = error
      }
    })
    return errors
  }
}
