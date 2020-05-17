import React, { PropTypes } from 'react'
import { Table, Popconfirm } from 'antd'
import { Link } from 'react-router'
import { PAGE_SIZE } from 'config/constants'
import { Segment } from 'components'
import date from 'helpers/date'

export default function List({ roles, handleDestroy }) {
  const columns = [
    { title: '角色名称', dataIndex: 'name', key: 'name' },
    { title: '备注', dataIndex: 'note', key: 'note' },
    {
      title: '创建时间',
      key: 'createdAt',
      render: (text, role) => date(role.createdAt),
    },
    {
      title: '操作',
      key: 'operation',
      render: (text, role) => (
        <span>
          <Link to={`/roles/${role.id}/edit`}>编辑</Link>
          <span className="ant-divider"></span>
          <Popconfirm title={`删除角色：${role.name}`} onConfirm={handleDestroy(role.id)}>
            <a href="#">删除</a>
          </Popconfirm>
        </span>
      ),
    },
  ]

  return (
    <Segment>
      <Table
        columns={columns}
        dataSource={roles}
        rowKey={role => role.id}
        bordered
        pagination={{ pageSize: PAGE_SIZE }}
      />
    </Segment>
  )
}

List.propTypes = {
  roles: PropTypes.array.isRequired,
  handleDestroy: PropTypes.func.isRequired,
}
