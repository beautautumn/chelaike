import React from 'react'
import { Modal } from 'antd'
import get from 'lodash/get'
const { confirm } = Modal

export default function cornmfirIfTooBig(data, checkFields, next) {
  const tooBigFields = []
  checkFields.forEach(field => {
    const { unit, name, key } = field
    const value = get(data, key)
    if ((unit === '万元' && value >= 1000) ||
        (unit === '元' && value >= 10000000) ||
        (unit === '万公里' && value >= 1000)) {
      tooBigFields.push(
        <div key={key}>{`${name}：${value} ${unit}`}</div>
      )
    }
  })

  if (tooBigFields.length > 0) {
    confirm({
      title: '下列单项超过1000万，请确认是否继续保存？',
      width: '500px',
      content: tooBigFields,
      onOk() { next() },
      onCancel() {},
    })
  } else {
    next()
  }
}
