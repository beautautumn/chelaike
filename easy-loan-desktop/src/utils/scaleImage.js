export default function scale(url, scaleStr) {
  const scaleArr = scaleStr.split('x')
  if (url.includes('image.che3bao.com')) {
    return `${url}?imageView/1/w/${scaleArr[0]}/h/${scaleArr[1]}`
  }
  return `${url}?x-oss-process=image/resize,m_fixed,w_${scaleArr[0]},h_${scaleArr[1]},limit_0`
}
