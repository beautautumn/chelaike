import React from 'react';
import { Table, Button } from 'antd';
import styles from './RepaymentTable.scss';
import { CarItem } from 'components';

export default class RepaymentTable extends React.Component {
  handleShowModal = record => () => {
    this.props.showModal(record);
  };

  handlePage = page => {
    this.props.fetch();
  };

  handleShowOperationHistoryModal = record => () => {
    this.props.showOperationHistoryModal(record);
  };

  render() {
    const {
      data,
      onPageChange,
      query,
      total,
      loading,
      currentUser,
      loanStatus,
      showEvaluateModal
    } = this.props;
    console.log('data', data);
    const columns = [
      {
        key: 'repayments',
        render: (text, record) => (
          <div>
            <div className={styles.title}>
              <span>{record.pcCreatedAt}</span>
              <span>申请号：{record.applyCode}</span>
              <span>{record.debtorName}</span>
            </div>
            <div className={styles.content}>
              <div className={styles.carList}>
                {record.cars.map((item, key) => {
                  item.disabled = true;
                  return (
                    <CarItem
                      item={item}
                      key={key}
                      showEvaluateModal={showEvaluateModal}
                    />
                  );
                })}
              </div>
              <div className={`${styles.column}`}>
                <div className={styles.contact}>
                  <div>
                    <span>联系人：</span>
                    <span>{record.contactName}</span>
                  </div>
                  <div>
                    <span>联系电话：</span>
                    <span>{record.contactPhone}</span>
                  </div>
                  <div>
                    <span>地址：</span>
                    <span>{record.address || ''}</span>
                  </div>
                </div>
              </div>
              <div className={styles.column}>
                <h3>{record.funderCompanyName}</h3>
              </div>
              <div className={styles.column}>
                还款：{record.repaymentAmountWan}万
              </div>
              <div className={styles.column}>
                <div>{record.assigneeName}</div>
              </div>
              <div
                className={styles.column}
                onClick={this.handleShowOperationHistoryModal(record)}
              >
                <span className={styles.transferHistory}>操作历史</span>
              </div>
              <div className={styles.column}>
                <div className={styles.lastStatus}>
                  <div>
                    <span>状态：</span>
                    <span>{loanStatus[record.state]}</span>
                  </div>
                  <div>
                    <span>备注：</span>
                    <span>{record.note}</span>
                  </div>
                  {currentUser.authorities.includes('还款单审核') && (
                    <div>
                      <Button onClick={this.handleShowModal(record)}>
                        修改状态
                      </Button>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        )
      }
    ];
    const paginationProps = {
      pageSize: +query.perPage,
      current: +query.page,
      total,
      onChange: onPageChange
    };
    return (
      <Table
        className={styles.table}
        loading={loading}
        columns={columns}
        dataSource={data}
        showHeader={false}
        rowKey="id"
        pagination={paginationProps}
        bordered
      />
    );
  }
}
