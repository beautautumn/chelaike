import React, { PropTypes } from 'react'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import { PAGE_SIZE } from 'config/constants'

export default function List({ channels, handleEdit, handleDestroy }) {
  const columns = [
    { title: '渠道名称', dataIndex: 'name', key: 'name' },
    { title: '备注', dataIndex: 'note', key: 'note' },
    { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
    {
      title: '操作',
      key: 'operation',
      render: (text, record) => (
        <span>
          <a href="#" onClick={handleEdit(record.id)}>编辑</a>
          <span className="ant-divider"></span>
          <Popconfirm title={`删除渠道：${record.name}`} onConfirm={handleDestroy(record)}>
            <a href="#">删除</a>
          </Popconfirm>
        </span>
      ),
    },
  ]

  return (
    <Segment className="ui segment">
      <Table
        columns={columns}
        dataSource={channels}
        rowKey={channel => channel.id}
        bordered
        pagination={{ pageSize: PAGE_SIZE }}
      />
    </Segment>
  )
}

List.propTypes = {
  channels: PropTypes.array.isRequired,
  handleEdit: PropTypes.func.isRequired,
  handleDestroy: PropTypes.func.isRequired,
}
