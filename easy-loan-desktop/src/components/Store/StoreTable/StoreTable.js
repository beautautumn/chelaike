import React from 'react';
import { Table, Popconfirm } from 'antd';
import styles from './StoreTable.scss';

class StoreTable extends React.Component {
  handleShowModal = record => () => {
    this.props.showModal(record);
  };

  handleDisabled = record => () => {
    this.props.destory({
      ...record,
      state: (record.state = 'false')
    });
  };

  handlePage = page => {
    this.props.fetch();
  };

  render() {
    const { data, query, total, onPageChange, loading } = this.props;
    if (data[0]) console.log('data', data[0].debtorName);
    let columns = [
      {
        key: 'name',
        title: '门店名称',
        render: (text, record) => {
          return <div>{record.name}</div>;
        }
      },
      {
        key: 'address',
        title: '门店地址',
        render: (text, record) => {
          return <div>{record.address}</div>;
        }
      },
      {
        key: 'userName',
        title: '盘库员',
        dataIndex: 'userName'
      },
      {
        key: 'operations',
        title: '操作',
        render: (text, record) => {
          return (
            <div className={styles.operations}>
              <a onClick={this.handleShowModal(record)}>修改</a>
              <Popconfirm
                title={`确认删除 ${record.name}？`}
                onConfirm={this.handleDisabled(record)}
              >
                <a>删除</a>
              </Popconfirm>
            </div>
          );
        }
      }
    ];
    /*if (currentUser.authorities.includes('门店管理')) {
      columns.push({
        key: 'operations',
        title: '操作',
        render: (text, record) => {
          return (
            <div className={styles.operations}>
              <a onClick={this.handleShowModal(record)}>修改</a>
              <Popconfirm
                title={`确认删除 ${record.name}？`}
                onConfirm={this.handleDisabled(record)}
              >
                <a>删除</a>
              </Popconfirm>
            </div>
          );
        }
      });
    }*/

    const paginationProps = {
      pageSize: +query.size,
      current: +query.page,
      total,
      onChange: onPageChange
    };
    return (
      <Table
        className={styles.table}
        columns={columns}
        dataSource={data}
        loading={loading}
        title={data => {
          return (
            <div className={styles.center}>
              {data[0] ? data[0].debtorName : null}
            </div>
          );
        }}
        size="middle"
        rowKey="id"
        pagination={paginationProps}
        bordered
      />
    );
  }
}

export default StoreTable;
