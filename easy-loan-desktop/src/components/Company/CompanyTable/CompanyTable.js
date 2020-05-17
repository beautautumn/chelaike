import React from 'react';
import { Table } from 'antd';
import styles from './CompanyTable.scss';
import { Link } from 'react-router-dom';

export default class CompanyTable extends React.Component {
  handleShowModal = record => () => {
    this.props.showModal(record);
  };
  handlePage = page => {
    this.props.fetch();
  };

  render() {
    const {
      data,
      query,
      total,
      onPageChange,
      loading,
      currentUser
    } = this.props;
    let columns = [
      {
        key: 'name',
        title: '商家名称',
        render: (text, record) => {
          return (
            <div>
              <div>{record.name}</div>
              <div>联系人：{record.contactName}</div>
              <div>电话：{record.contactPhone}</div>
              <div>地址：{record.address}</div>
            </div>
          );
        }
      },
      {
        key: 'singleCarRate',
        title: '单车贷款比例',
        render: (text, record) => {
          if (record.singleCarRate) {
            return `${record.singleCarRate}%`;
          }
          return null;
        }
      },
      {
        key: 'totalCurrentCreditWan',
        title: '总当前授信',
        render: (text, record) => {
          if (record.totalCurrentCreditWan) {
            return `${record.totalCurrentCreditWan}万`;
          }
          return null;
        }
      },
      {
        key: 'accreditedRecords',
        title: '最大授信额度／当前授信／允许部分还款',
        render: (text, { loanAccreditedRecordDtosList }) => {
          if (
            loanAccreditedRecordDtosList &&
            loanAccreditedRecordDtosList.length > 0
          ) {
            return loanAccreditedRecordDtosList.map(item => {
              return (
                <div className={styles.accreditedRecord} key={item.id}>
                  <span>{item.funderCompany.name}</span>
                  <span>
                    {item.limitAmountWan}万／{item.currentCreditAmountWan}万／{item.allowPartRepay
                      ? '是'
                      : '否'}
                  </span>
                </div>
              );
            });
          }
          return null;
        }
      },
      {
        key: 'assigneeName',
        title: '归属业务员',
        dataIndex: 'assigneeName'
      },
      {
        key: 'operations',
        title: '操作',
        render: (text, record) => {
          return (
            <div className={styles.operations}>
              {currentUser.authorities.includes('车商授信管理') && (
                <a onClick={this.handleShowModal(record)}>修改</a>
              )}
              {currentUser.authorities.includes('车商信息管理') && (
                <Link className={styles.button} to={`/companies/${record.id}`}>
                  门店
                </Link>
              )}
            </div>
          );
        }
      }
    ];
    /*if (currentUser.authorities.includes('车商授信管理')) {
      columns.push({
        key: 'operations',
        title: '操作',
        render: (text, record) => {
          return (
            <div className={styles.operations}>
              <a onClick={this.handleShowModal(record)}>修改</a>
              <Link className={styles.button} to={`/companies/${record.id}`}>
                门店
              </Link>
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
        size="middle"
        rowKey="id"
        pagination={paginationProps}
        bordered
      />
    );
  }
}
