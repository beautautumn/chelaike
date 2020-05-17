import React, { PropTypes } from 'react'
import { Col } from 'antd'
import { AuthorityTree } from 'components'

export default function ThirdColumn({ fields }) {
  const { authorities, authorityType } = fields
  const authorityTypeValue = authorityType.value || authorityType.defaultValue
  return (
    <Col span="7" offset="1">
      <AuthorityTree {...authorities} disabled={authorityTypeValue === 'role'} />
    </Col>
  )
}

ThirdColumn.propTypes = {
  fields: PropTypes.object.isRequired,
}
