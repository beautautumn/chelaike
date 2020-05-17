import React from 'react'
import { Segment, ShopSelect } from 'components'
import { Button, Row, Col } from 'antd'

export default function ToolBar({ searchQuery, handleSearch, handleExport }) {
  return (
    <Segment>
      <Row justify="space-between">
        <Col span="4">
          <ShopSelect value={searchQuery.shopId} onChange={handleSearch} />
        </Col>
        <Col span="2" offset="18">
          <Button size="large" onClick={handleExport}>导出 Excel</Button>
        </Col>
      </Row>
    </Segment>
  )
}
