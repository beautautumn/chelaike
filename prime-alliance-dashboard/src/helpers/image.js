export function scale(url, scaleStr) {
  const scaleArr = scaleStr.split('x')
  if (url.includes('image.che3bao.com')) {
    return `${url}?imageView/1/w/${scaleArr[0]}/h/${scaleArr[1]}`
  }
  return `${url}@${scaleArr[0]}w_${scaleArr[1]}h_1e_1c_2o`
}
