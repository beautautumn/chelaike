export function scale(url, scaleStr) {
  const scaleArr = scaleStr.split('x')
  return `${url}?x-oss-process=image/resize,w_${scaleArr[0]},h_${scaleArr[1]}`
}
