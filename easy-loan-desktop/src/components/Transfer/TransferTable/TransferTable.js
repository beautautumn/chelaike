import React from 'react';
import { Table, Button } from 'antd';
import styles from './TransferTable.scss';
import newCarImg from './new.svg';
import originCarImg from './origin.svg';
import { CarItem } from 'components';

export default class TransferTable extends React.Component {
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
    const markImgMap = {
      is_replaced: newCarImg,
      will_replace: originCarImg
    };
    const columns = [
      {
        key: 'transfer',
        render: (text, record) => (
          <div>
            <div className={styles.title}>
              <span>{record.pcCreatedAt}</span>
              <span>申请号：{record.applyCode}</span>
              <span>{record.spCompany.name}</span>
            </div>
            <div className={styles.content}>
              <div className={styles.carList}>
                <div>当前借款车辆</div>
                {record.loanValuationDto.loanBillCarForTransferDtos.map(
                  (item, key) => {
                    return (
                      <CarItem
                        item={item.car}
                        key={key}
                        remarkImg={markImgMap[item.state]}
                        showEvaluateModal={showEvaluateModal}
                      />
                    );
                  }
                )}
              </div>
              <div className={styles.carList}>
                <div>替换车辆</div>
                {record.replaceValuationDto.loanBillCarForTransferDtos.map(
                  (item, key) => {
                    return (
                      <CarItem
                        item={item.car}
                        key={key}
                        remarkImg={markImgMap[item.state]}
                        showEvaluateModal={showEvaluateModal}
                      />
                    );
                  }
                )}
              </div>
              <div className={styles.column}>
                <div className={styles.contact}>
                  <div>{record.debtor.name}</div>
                  <div>联系人：{record.debtor.contactName}</div>
                  <div>联系电话：{record.debtor.contactPhone}</div>
                </div>
              </div>
              <div className={styles.column}>
                <div>
                  <div>{record.funderCompany.name}</div>
                  <div>已放款，{record.borrowedAmountWan}万</div>
                </div>
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
                  {currentUser.authorities.includes('借款单审核') && (
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
        scroll={{ x: 1400 }}
        bordered
      />
    );
  }
}
