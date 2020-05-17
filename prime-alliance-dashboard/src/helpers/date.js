import moment from 'moment'

export default (dateStr, format = 'default') => {
  if (!dateStr) {
    return ''
  }
  const date = new Date(dateStr)
  const formats = {
    short: 'YYYY-MM',
    full: 'YYYY-MM-DD HH:mm:ss',
    default: 'YYYY-MM-DD',
  }
  if (formats[format]) {
    return moment(date).format(formats[format])
  }
  return moment(date).format(format)
}
