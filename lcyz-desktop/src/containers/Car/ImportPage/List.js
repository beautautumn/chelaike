import React, { Component, PropTypes } from 'react'
import { Table } from 'antd'
import { Segment } from 'components'

export default class List extends Component {
  static propTypes = {
    companies: PropTypes.array,
    handleImport: PropTypes.func.isRequired,
  }

  render() {
    const { companies, handleImport } = this.props

    const columns = [
      { title: '公司名称', dataIndex: 'name', key: 'name' },
      { title: '车辆数', dataIndex: 'count', key: 'count' },
      {
        title: '操作',
        key: 'operation',
        render: (text, company) => (
          <a href="#" onClick={handleImport(company.id)}>导入</a>
        )
      },
    ]

    return (
      <Segment className="ui segment">
        <Table
          dataSource={companies}
          columns={columns}
          rowKey={company => company.id}
          pagination={false}
        />
      </Segment>
    )
  }
}
