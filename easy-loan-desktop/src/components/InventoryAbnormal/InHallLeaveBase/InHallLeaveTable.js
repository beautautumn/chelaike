import React from 'react'
import {Table} from 'antd'
import styles from './InHallLeaveTable.scss'

class InHallLeaveTable extends React.Component {

  handlePage = page => {
    this.props.fetch()
  }

  render() {
    const {data, total, onPageChange, loading} = this.props
    let columns = [
      {
        key: 'carPic',
        title: '车辆图片',
        render: (text, record) => {
          return (
              <div>{record.carPic}</div>
          )
        }
      },
      {
        key: 'carName',
        title: '车辆名称',
        dataIndex: 'carName'
      },
      {
        key: 'carVin',
        title: '车架号',
        dataIndex: 'carVin'
      },
      {
        key: 'inventoryAdd',
        title: '盘库地址',
        dataIndex: 'inventoryAdd'
      },
      {
        key: 'state',
        title: '状态',
        dataIndex: 'state'
      }
    ]

    const paginationProps = {
      /*pageSize: +query.size,
      current: +query.page,*/
      total,
      onChange: onPageChange
    }
    return (
        <Table
            className={styles.table}
            columns={columns}
            dataSource={data}
            loading={loading}
            size="middle"
            rowKey="id"
            pagination={paginationProps}
            bordered/>
    )
  }
}

export default InHallLeaveTable;