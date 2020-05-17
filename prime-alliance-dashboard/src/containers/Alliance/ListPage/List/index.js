import React, { PropTypes } from 'react'
import { Table } from 'antd'
import { PAGE_SIZE } from 'config/constants'
import { Segment } from 'components'
import styles from '../style.scss'
import date from 'helpers/date'

export default function List({ companies, handleEdit }) {
  const columns = [
    { title: '商家名称', dataIndex: 'name', key: 'name' },
    { title: '联盟别称', dataIndex: 'nickname', key: 'nickname' },
    { title: '联系人', dataIndex: 'contact', key: 'contact' },
    { title: '联系电话', dataIndex: 'contactMobile', key: 'contactMobile' },
    { title: '看车地址', dataIndex: 'street', key: 'street', width: '25%' },
    {
      title: '加入联盟时间',
      key: 'joinedAt',
      render: (text, company) => date(company.joinedAt),
    },
    {
      title: '操作',
      key: 'operation',
      render: (text, company) => (
        <span>
          <a href="#" onClick={handleEdit(company.id)}>编辑</a>
        </span>
      ),
    },
  ]

  return (
    <Segment>
      <h2 className={styles.tableTitle}>联盟成员共{companies.length}家</h2>
      <Table
        columns={columns}
        dataSource={companies}
        rowKey={company => company.id}
        bordered
        pagination={{ pageSize: PAGE_SIZE }}
      />
    </Segment>
  )
}

List.propTypes = {
  companies: PropTypes.array.isRequired,
  handleEdit: PropTypes.func.isRequired,
}
