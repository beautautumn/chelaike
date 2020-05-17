import React from 'react';
import { Table, Button, Tag, Popconfirm } from 'antd';
import styles from './UserTable.scss';
import isArray from 'lodash/isArray';

class UserTable extends React.Component {
  handleAdd = () => {
    this.props.showModal();
  };

  handleEdit = record => () => {
    this.props.showModal(record);
  };

  handleDisabled = record => () => {
    this.props.update({
      ...record,
      state: record.state === 'disabled' ? 'enabled' : 'disabled'
    });
  };

  render() {
    const { data, loading, query, total, onPageChange } = this.props;
    const columns = [
      {
        key: 'name',
        title: '姓名',
        dataIndex: 'name'
      },
      {
        key: 'phone',
        title: '电话',
        dataIndex: 'phone'
      },
      {
        key: 'type',
        title: '员工类型',
        dataIndex: 'type'
      },
      {
        key: 'state',
        title: '状态',
        dataIndex: 'state',
        render(value) {
          return value === 'disabled' ? '禁用' : '启用';
        }
      },
      {
        key: 'role',
        title: '角色',
        dataIndex: 'authorityRoleIds',
        render: value => {
          if (isArray(value) && value.length > 0 && this.props.roleById) {
            console.log('this.props.roleById', this.props.roleById);
            return this.props.roleById[value[0]].name;
          }
        }
      },
      {
        key: 'authorities',
        title: '权限',
        dataIndex: 'authorities',
        width: 600,
        render(items) {
          if (items) {
            return items.map(item => (
              <div className={styles.padding}>
                <Tag color="green" key={item}>
                  {item}
                </Tag>
              </div>
            ));
          }
        }
      },
      {
        key: 'operations',
        render: (text, record) => {
          return (
            <div className={styles.operations}>
              <a onClick={this.handleEdit(record)}>修改</a>
              <Popconfirm
                title={`确认${
                  record.state === 'disabled' ? '启用' : '禁用'
                }该用户？`}
                onConfirm={this.handleDisabled(record)}
              >
                <a>{record.state === 'disabled' ? '启用' : '禁用'}</a>
              </Popconfirm>
            </div>
          );
        }
      }
    ];
    const paginationProps = {
      pageSize: +query.size,
      current: +query.page,
      total,
      onChange: onPageChange
    };
    return (
      <div>
        <Button onClick={this.handleAdd} className={styles.addButton}>
          新增员工
        </Button>
        <Table
          className={styles.table}
          columns={columns}
          dataSource={data}
          loading={loading}
          size="middle"
          rowKey="id"
          pagination={paginationProps}
          bordered
        />
      </div>
    );
  }
}

export default UserTable;
