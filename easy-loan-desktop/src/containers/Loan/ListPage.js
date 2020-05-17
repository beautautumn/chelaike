import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import {
  LoanListSearchForm,
  LoanTable,
  LoanStatusModal,
  TransferHistoryModal,
  OperationHistoryModal,
  EvaluateModal
} from 'components';
import {
  fetch,
  changeStatus,
  setVisible,
  setHistoryVisible,
  setOperationHistoryVisible,
  fetchHistory,
  setEvaluateVisible,
  setEvaluate,
  fetchChe300Evaluate
} from '../../models/reducers/loan';
import entitiesSelector from '../../utils/entitiesSelector';
import { fetch as fetchSeries } from '../../models/reducers/series';
import pick from 'lodash/pick';

class ListPage extends React.Component {
  componentDidMount() {
    const { fetch, fetchSeries } = this.props;
    fetch();
    fetchSeries({ name: null });
  }

  handleBrandChange = brand => {
    this.props.fetchSeries({ name: brand });
  };

  showModal = record => {
    this.form.resetFields();
    const values = pick(record, [
      'id',
      'borrowedAmountWan',
      'note',
      'totalCarValuationAmountWan',
      'singleCarRate',
      'estimateBorrowAmountWan'
    ]);
    values.state = record.state;
    this.form.setFieldsValue(values);
    this.props.setVisible(true);
  };

  showTransferHistoryModal = record => {
    this.props.fetchHistory({ id: record.id });
  };

  showOperationHistoryModal = record => {
    this.props.setOperationHistoryVisible({
      operationHistoryVisible: true,
      loanHistoryList: record.loanHistoryList
    });
  };

  handleOperationHistoryCancel = () => {
    this.props.setOperationHistoryVisible({
      operationHistoryVisible: false
    });
  };

  showEvaluateModal = carData => {
    this.props.setEvaluateVisible({ evaluateVisible: true, car: carData });
  };

  handleEvaluateCancel = () => {
    this.props.setEvaluateVisible({ evaluateVisible: false, car: {} });
  };

  handleEvaluateOk = () => {
    const car = this.props.car;
    if (car.disabled) {
      this.props.setEvaluateVisible({ evaluateVisible: false, car: {} });
    } else {
      this.props.setEvaluate({
        id: car.id,
        estimatePriceWan: car.estimatePriceWan
      });
    }
  };

  handleEvaluateChange = value => {
    const car = this.props.car;
    car.estimatePriceWan = value;
    this.props.setEvaluateVisible({ evaluateVisible: true, car: car });
  };

  handleChe300Evaluate = () => {
    this.props.fetchChe300Evaluate({ id: this.props.car.id });
  };

  handleQuery = query => {
    this.props.fetch({ page: 1, query, type: 'pc' });
  };

  handlePage = page => {
    this.props.fetch({ page });
  };

  handleCancel = () => {
    this.props.setVisible(false);
  };

  handleHistoryCancel = () => {
    this.props.setHistoryVisible(false);
  };

  handleOk = () => {
    this.form.validateFields((err, values) => {
      if (err) return;
      this.props.changeStatus(values);
    });
  };

  saveFormRef = form => (this.form = form);

  render() {
    const {
      loans,
      query,
      brands,
      series,
      currentUser,
      loanStatus,
      transferHistory,
      loading,
      confirmLoading,
      visible,
      historyVisible,
      total,
      assignees,
      operationHistoryVisible,
      loanHistoryList,
      statusMap,
      evaluateVisible,
      car
    } = this.props;
    return (
      <div>
        <LoanListSearchForm
          onQuery={this.handleQuery}
          loanStatus={loanStatus}
          onBrandChange={this.handleBrandChange}
          brands={brands}
          series={series}
          assignees={assignees}
        />
        <LoanTable
          onPageChange={this.handlePage}
          loading={loading}
          total={total}
          query={query}
          data={loans}
          currentUser={currentUser}
          loanStatus={loanStatus}
          showModal={this.showModal}
          showTransferHistoryModal={this.showTransferHistoryModal}
          showOperationHistoryModal={this.showOperationHistoryModal}
          showEvaluateModal={this.showEvaluateModal}
        />
        <LoanStatusModal
          ref={this.saveFormRef}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          loanStatus={loanStatus}
          confirmLoading={confirmLoading}
          visible={visible}
        />
        <TransferHistoryModal
          historyVisible={historyVisible}
          data={transferHistory}
          onCancel={this.handleHistoryCancel}
          showEvaluateModal={this.showEvaluateModal}
        />
        <OperationHistoryModal
          historyVisible={operationHistoryVisible}
          statusMap={statusMap}
          data={loanHistoryList}
          onCancel={this.handleOperationHistoryCancel}
        />
        <EvaluateModal
          visible={evaluateVisible}
          data={car}
          onCancel={this.handleEvaluateCancel}
          onOk={this.handleEvaluateOk}
          onEvaluate={this.handleChe300Evaluate}
          handleEvaluateChange={this.handleEvaluateChange}
        />
      </div>
    );
  }
}

ListPage.propTypes = {
  loans: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  fetch: PropTypes.func.isRequired,
  fetchHistory: PropTypes.func.isRequired,
  changeStatus: PropTypes.func.isRequired,
  enums: PropTypes.object.isRequired,
  loanStatus: PropTypes.object.isRequired,
  brands: PropTypes.array.isRequired,
  assignees: PropTypes.array.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  historyVisible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired
};

export default connect(
  state => {
    const { enums, brands, assignees, user } = state.profile;
    return {
      loans: entitiesSelector('loans')(state),
      transferHistory: state.loans.transferHistory,
      operationHistoryVisible: state.loans.operationHistoryVisible,
      loanHistoryList: state.loans.loanHistoryList,
      evaluateVisible: state.loans.evaluateVisible,
      car: state.loans.car,
      total: state.loans.total,
      query: state.loans.query,
      loading: state.loans.loading,
      confirmLoading: state.loans.confirmLoading,
      visible: state.loans.visible,
      historyVisible: state.loans.historyVisible,
      enums: state.profile.enums,
      brands,
      series: state.series.data,
      currentUser: user,
      assignees,
      statusMap: enums.loanBill.state,
      loanStatus: pick(enums.loanBill.state, [
        'borrow_applied',
        'borrow_submitted',
        'reviewed',
        'borrow_confirmed',
        'borrow_refused',
        'canceled',
        'closed'
      ])
    };
  },
  {
    fetch,
    changeStatus,
    setVisible,
    setHistoryVisible,
    setOperationHistoryVisible,
    fetchSeries,
    fetchHistory,
    setEvaluateVisible,
    setEvaluate,
    fetchChe300Evaluate
  }
)(ListPage);
