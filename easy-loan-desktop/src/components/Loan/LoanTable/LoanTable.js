import React from 'react';
import { Table, Button } from 'antd';
import styles from './LoanTable.scss';
import { CarItem } from 'components';

class LoanTable extends React.Component {
  handleShowModal = record => () => {
    this.props.showModal(record);
  };

  handleShowTransferHistoryModal = record => () => {
    this.props.showTransferHistoryModal(record);
  };

  handleShowOperationHistoryModal = record => () => {
    this.props.showOperationHistoryModal(record);
  };

  handlePage = page => {
    this.props.fetch();
  };

  render() {
    const {
      data,
      onPageChange,
      query,
      total,
      loading,
      currentUser,
      showEvaluateModal
    } = this.props;
    const columns = [
      {
        key: 'loan',
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
                <h3>{record.assigneeName}</h3>
              </div>
              <div
                className={styles.column}
                onClick={this.handleShowTransferHistoryModal(record)}
              >
                换车历史<span className={styles.transferHistory}>
                  （{record.countReplaceCar}）
                </span>
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
                    <span>{record.stateText}</span>
                  </div>
                  <div>
                    <span>金额：</span>
                    <span>{record.borrowedAmountWan}万</span>
                  </div>
                  <div>
                    <span>备注：</span>
                    <span>{record.note}</span>
                  </div>
                  {currentUser.authorities.includes('借款单审核') && (
                    <Button onClick={this.handleShowModal(record)}>
                      修改状态
                    </Button>
                  )}
                </div>
              </div>
            </div>
          </div>
        )
      }
    ];
    const paginationProps = {
      pageSize: +query.size,
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

export default LoanTable;
