import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import {
  LoanListSearchForm,
  TransferTable,
  TransferTableStatusModal,
  OperationHistoryModal,
  EvaluateModal
} from 'components';
import {
  fetch,
  changeStatus,
  setVisible,
  setEvaluate,
  showEvaluateModal,
  fetchChe300Evaluate,
  setEvaluateVisible,
  setOperationHistoryVisible
} from '../../models/reducers/transfer';
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

  handleQuery = query => {
    this.props.fetch({ page: 1, query, type: 'pc' });
  };

  handlePage = page => {
    this.props.fetch({ page });
  };

  handleCancel = () => {
    this.props.setVisible(false);
  };

  handleOk = () => {
    this.form.validateFields((err, values) => {
      if (err) return;
      this.props.changeStatus(values);
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

  showModal = record => {
    this.form.resetFields();
    const values = pick(record, ['id', 'note']);
    values.state = record.state;
    this.form.setFieldsValue(values);
    this.props.setVisible(true);
  };

  saveFormRef = form => (this.form = form);

  render() {
    const {
      transfers,
      loanStatus,
      brands,
      series,
      query,
      total,
      currentUser,
      confirmLoading,
      visible,
      loading,
      assignees,
      statusMap,
      operationHistoryVisible,
      loanHistoryList,
      evaluateVisible,
      car
    } = this.props;
    return (
      <div>
        <LoanListSearchForm
          onQuery={this.handleQuery}
          onBrandChange={this.handleBrandChange}
          brands={brands}
          series={series}
          loanStatus={loanStatus}
          assignees={assignees}
        />
        <TransferTable
          onPageChange={this.handlePage}
          loading={loading}
          total={total}
          query={query}
          data={transfers}
          currentUser={currentUser}
          loanStatus={loanStatus}
          showModal={this.showModal}
          showOperationHistoryModal={this.showOperationHistoryModal}
          showEvaluateModal={this.showEvaluateModal}
        />
        <TransferTableStatusModal
          ref={this.saveFormRef}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          loanStatus={loanStatus}
          confirmLoading={confirmLoading}
          visible={visible}
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
  transfers: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  fetch: PropTypes.func.isRequired,
  changeStatus: PropTypes.func.isRequired,
  loanStatus: PropTypes.object.isRequired,
  brands: PropTypes.array.isRequired,
  assignees: PropTypes.array.isRequired,
  currentUser: PropTypes.object.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired
};

export default connect(
  state => {
    const { enums, brands, assignees, user } = state.profile;
    return {
      transfers: entitiesSelector('transfers')(state),
      total: state.transfers.total,
      evaluateVisible: state.transfers.evaluateVisible,
      car: state.transfers.car,
      query: state.transfers.query,
      loading: state.transfers.loading,
      confirmLoading: state.transfers.confirmLoading,
      visible: state.transfers.visible,
      brands,
      series: state.series.data,
      currentUser: user,
      assignees,
      operationHistoryVisible: state.transfers.operationHistoryVisible,
      loanHistoryList: state.transfers.loanHistoryList,
      statusMap: enums.loanBill.state,
      loanStatus: enums.replaceCarsBill.state
    };
  },
  {
    fetch,
    changeStatus,
    setVisible,
    fetchSeries,
    showEvaluateModal,
    setOperationHistoryVisible,
    setEvaluate,
    setEvaluateVisible,
    fetchChe300Evaluate
  }
)(ListPage);
