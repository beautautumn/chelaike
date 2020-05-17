import React, { Component, PropTypes } from 'react'
import { Table, Tag, Popconfirm } from 'antd'
import { Link } from 'react-router'
import { PAGE_SIZE } from 'constants'
import { Segment } from 'components'
import date from 'helpers/date'
import styles from './List.scss'

export default class List extends Component {
  static propTypes = {
    users: PropTypes.array.isRequired,
    usersById: PropTypes.object,
    shopsById: PropTypes.object,
    rolesById: PropTypes.object,
    handleSwitch: PropTypes.func.isRequired,
    handleDestroy: PropTypes.func.isRequired,
    handlePage: PropTypes.func.isRequired,
    query: PropTypes.object.isRequired,
    total: PropTypes.number,
  }

  render() {
    const {
      users,
      usersById,
      shopsById,
      rolesById,
      handleSwitch,
      handleDestroy,
      total,
      query,
      handlePage,
    } = this.props

    const columns = [
      { title: '姓名', dataIndex: 'name', key: 'name' },
      { title: '用户名', dataIndex: 'username', key: 'username' },
      { title: '手机号码', dataIndex: 'phone', key: 'phone' },
      {
        title: '所属分店',
        key: 'shop',
        render: (text, user) => user.shop && shopsById[user.shop].name
      },
      {
        title: '所属经理',
        key: 'manager',
        render: (text, user) => user.manager && usersById[user.manager].name
      },
      {
        title: '所属角色',
        key: 'roles',
        render: (text, user) => (
           user.authorityRoles.map(id => (
             <Tag key={id} color="blue">{rolesById[id].name}</Tag>
           )
          )
        )
      },
      {
        title: '启用状态',
        key: 'state',
        render: (text, user) => ({ enabled: '已启用', disabled: '已禁用' }[user.state])
      },
      {
        title: '创建时间',
        key: 'createdAt',
        render: (text, user) => date(user.createdAt)
      },
      {
        title: '操作',
        key: 'operation',
        render: (text, user) => (
          <span>
            <Link to={`/users/${user.id}/edit`}>编辑</Link>
            <span className="ant-divider"></span>
            <a href="#" onClick={handleSwitch(user)}>
              {{ enabled: '禁用', disabled: '启用' }[user.state]}
            </a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除员工：${user.name}`} onConfirm={handleDestroy(user)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const pagination = {
      pageSize: PAGE_SIZE,
      current: +query.page,
      total,
      onChange: handlePage,
    }

    return (
      <Segment className="ui segment">
        <Table
          columns={columns}
          dataSource={users}
          rowKey={car => car.id}
          rowClassName={user => styles[user.state]}
          bordered
          pagination={pagination}
        />
      </Segment>
    )
  }
}
