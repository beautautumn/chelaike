export function scale(url, scaleStr) {
  const scaleArr = scaleStr.split('x')
  return `${url}?imageView/1/w/${scaleArr[0]}/h/${scaleArr[1]}`
}
