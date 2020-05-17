import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { ImageManager } from 'components'

const carLocations = [
  '左前45度',
  '前排座椅-左前门',
  '左侧面',
  '后排座椅-左后门',
  '左后45度',
  '后面',
  '后备箱',
  '右后45度',
  '后排座椅-右后门',
  '右侧面',
  '前排座椅-右前门',
  '右前45度',
  '正面',
  '发动机舱',
  '轮毂',
  '中控台',
  '里程表',
  '内饰',
  '天窗',
  '其他',
]


function Form({ oss, fields }) {
  return (
    <ImageManager
      oss={oss}
      locations={carLocations}
      hasCover
      {...fields.car.allianceImagesAttributes}
    />
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  oss: PropTypes.object,
}

export default reduxForm({
  form: 'carImage',
  fields: ['car.allianceImagesAttributes'],
})(Form)
