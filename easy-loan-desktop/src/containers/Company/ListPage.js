import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import {
  CompanySearchForm,
  CompanyTable,
  CompanyCreditModal
} from 'components';
import {
  fetch,
  create,
  update,
  setVisible
} from '../../models/reducers/company';
import entitiesSelector from '../../utils/entitiesSelector';

class ListPage extends React.Component {
  componentDidMount() {
    this.props.fetch();
  }

  showModal = record => {
    this.form.resetFields();
    const { funders } = this.props;
    console.log(',,,,,,,,,', funders);

    const loanAccreditedRecordDtosList = funders.map(funder => ({
      funderCompany: {
        id: funder.id,
        name: funder.name
      }
    }));
    const values = { loanAccreditedRecordDtosList };
    if (record) {
      values.id = record.id;
      values.name = record.name;
      values.contactName = record.contactName;
      values.contactPhone = record.contactPhone;
      values.address = record.address;
      values.shopId = record.shopId;
      values.assigneeId = `${record.assigneeId}`;
      values.singleCarRate = record.singleCarRate;
      values.totalCurrentCreditWan = record.totalCurrentCreditWan;
      loanAccreditedRecordDtosList.forEach(a => {
        const match = record.loanAccreditedRecordDtosList.find(
          r => r.funderCompany.id === a.funderCompany.id
        );
        if (match) {
          a.limitAmountWan = match.limitAmountWan;
          a.allowPartRepay = match.allowPartRepay;
          a.currentCreditAmountWan = match.currentCreditAmountWan;
        }
      });
    }

    this.form.resetFields();
    this.form.setFieldsValue(values);
    this.props.setVisible(true);
  };

  handleQuery = query => {
    this.props.fetch({ page: 1, query });
  };

  handlePage = page => {
    this.props.fetch({ page });
  };

  handleCancel = () => {
    this.props.setVisible(false);
  };

  handleOk = () => {
    this.form.validateFields((err, values) => {
      if (err) {
        return;
      }
      if (values.id) {
        this.props.update(values);
        console.log('车商修改', values);
      } else {
        this.props.create(values);
        console.log('车商新增', values);
      }
    });
  };

  saveFormRef = form => (this.form = form);

  render() {
    const {
      companies,
      loading,
      confirmLoading,
      visible,
      query,
      total,
      funders,
      currentUser,
      assignees,
      inventors
    } = this.props;

    return (
      <div>
        <CompanySearchForm
          assignees={assignees}
          inventors={inventors}
          onQuery={this.handleQuery}
          currentUser={currentUser}
          showModal={this.showModal}
        />
        <CompanyTable
          onPageChange={this.handlePage}
          loading={loading}
          total={total}
          query={query}
          data={companies}
          currentUser={currentUser}
          showModal={this.showModal}
        />
        <CompanyCreditModal
          ref={this.saveFormRef}
          funders={funders}
          assignees={assignees}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          confirmLoading={confirmLoading}
          visible={visible}
        />
      </div>
    );
  }
}

ListPage.propTypes = {
  companies: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  fetch: PropTypes.func.isRequired,
  create: PropTypes.func.isRequired,
  update: PropTypes.func.isRequired,
  setVisible: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired,
  funders: PropTypes.array.isRequired,
  assignees: PropTypes.array.isRequired,
  inventors: PropTypes.array.isRequired
};

export default connect(
  state => ({
    companies: entitiesSelector('companies')(state),
    total: state.companies.total,
    query: state.companies.query,
    loading: state.companies.loading,
    confirmLoading: state.companies.confirmLoading,
    visible: state.companies.visible,
    funders: state.profile.funders,
    currentUser: state.profile.user,
    assignees: state.profile.assignees,
    inventors: state.profile.inventors
  }),
  { fetch, create, update, setVisible }
)(ListPage);
