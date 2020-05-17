import React, { PropTypes } from 'react'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import { PAGE_SIZE } from 'config/constants'

export default function List({ levels, handleEdit, handleDestroy }) {
  const columns = [
    { title: '客户等级', dataIndex: 'name', key: 'name' },
    { title: '最大跟进间隔天数', dataIndex: 'timeLimitation', key: 'timeLimitation' },
    { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
    {
      title: '操作',
      key: 'operation',
      render: (text, record) => (
        <span>
          <a href="#" onClick={handleEdit(record.id)}>编辑</a>
          <span className="ant-divider"></span>
          <Popconfirm title={`删除客户等级：${record.name}`} onConfirm={handleDestroy(record)}>
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
        dataSource={levels}
        rowKey={level => level.id}
        bordered
        pagination={{ pageSize: PAGE_SIZE }}
      />
    </Segment>
  )
}

List.propTypes = {
  levels: PropTypes.array.isRequired,
  handleEdit: PropTypes.func.isRequired,
  handleDestroy: PropTypes.func.isRequired,
}
