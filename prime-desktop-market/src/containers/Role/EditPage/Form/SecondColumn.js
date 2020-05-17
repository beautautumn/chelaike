import React from 'react'
import { AuthorityTree } from 'components'
import { Col } from 'antd'

export default ({ fields }) => (
  <Col span="12">
    <AuthorityTree {...fields.authorities} />
  </Col>
)
