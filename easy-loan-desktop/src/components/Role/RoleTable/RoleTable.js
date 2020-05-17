import React from 'react';
import { Table, Button, Tag } from 'antd';
import styles from './RoleTable.scss';

class RoleTable extends React.Component {
  handleAdd = () => {
    this.props.showModal();
  };

  handleEdit = record => () => {
    this.props.showModal(record);
  };

  render() {
    const { data, loading } = this.props;
    const columns = [
      {
        key: 'name',
        title: '名称',
        dataIndex: 'name'
      },
      {
        key: 'authorities',
        title: '权限',
        dataIndex: 'authorities',
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
        key: 'note',
        title: '备注',
        dataIndex: 'note'
      },
      {
        key: 'operations',
        render: (text, record) => (
          <div className={styles.operations}>
            <a onClick={this.handleEdit(record)}>修改</a>
          </div>
        )
      }
    ];
    return (
      <div>
        <Button onClick={this.handleAdd} className={styles.addButton}>
          新增角色
        </Button>
        <Table
          className={styles.table}
          columns={columns}
          dataSource={data}
          pagination={false}
          loading={loading}
          size="middle"
          rowKey="id"
          bordered
        />
      </div>
    );
  }
}

export default RoleTable;
