export function unit(number, suffix) {
  if (number) {
    return number.toString() + suffix
  }
  return null
}
