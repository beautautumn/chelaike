import React from 'react'
import { Col } from 'antd'
import { AuthorityTree } from 'components'

export default ({ fields, authorities }) => (
  <Col span="7" offset="1">
    <div>权限：</div>
    <AuthorityTree {...fields.viewItems} authorities={authorities} disabled={false} />
  </Col>
)

