export default function convertFormFields(values) {
  if (!values) return {}
  return Object.getOwnPropertyNames(values).reduce((acc, key) => {
    acc[key] = { value: values[key] }
    return acc
  }, {})
}
