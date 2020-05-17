const layoutCache = {}
export default function layoutConfig(label, wrapper) {
  const key = `label-${label},wrapper-${wrapper}`
  if (!layoutCache[key]) {
    layoutCache[key] = {
      labelCol: { span: label },
      wrapperCol: { span: wrapper }
    }
  }
  return layoutCache[key]
}
