import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { fetch, create, update, setVisible } from '../../models/reducers/user';
import { fetch as fetchRoles } from '../../models/reducers/role';
import entitiesSelector from '../../utils/entitiesSelector';
import pick from 'lodash/pick';
import isArray from 'lodash/isArray';

import { UserTable, UserModal } from 'components';

class ListPage extends React.Component {
  componentDidMount() {
    this.props.fetchRoles();
    this.props.fetch();
  }

  showModal = record => {
    this.form.resetFields();
    if (record) {
      let easyLoanAuthorityRoleId = null;
      if (
        isArray(record.authorityRoleIds) &&
        record.authorityRoleIds.length > 0
      ) {
        easyLoanAuthorityRoleId = record.authorityRoleIds[0];
      }
      const values = pick(record, [
        'id',
        'name',
        'phone',
        'authorities',
        'authorityType',
        'type',
        'typeId'
      ]);
      this.form.setFieldsValue({ ...values, easyLoanAuthorityRoleId });
    }
    this.props.setVisible(true);
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
      let authorityRoleIds = [];
      if (values.authorityType === 'role' && values.easyLoanAuthorityRoleId) {
        authorityRoleIds = [values.easyLoanAuthorityRoleId];
      }
      const body = {
        ...pick(values, [
          'id',
          'name',
          'phone',
          'authorities',
          'authorityType',
          'type',
          'typeId'
        ]),
        authorityRoleIds
      };
      if (values.id) {
        this.props.update(body);
        console.log('修改', body);
      } else {
        this.props.create(body);
        console.log('新增', body);
      }
    });
  };

  saveFormRef = form => (this.form = form);

  render() {
    const {
      users,
      update,
      roleById,
      authorities,
      query,
      loading,
      confirmLoading,
      visible,
      total,
      roles,
      funders,
      userTypes
    } = this.props;
    //console.log('roleById', roleById);
    return (
      <div>
        <UserTable
          onPageChange={this.handlePage}
          showModal={this.showModal}
          loading={loading}
          update={update}
          roleById={roleById}
          total={total}
          query={query}
          data={users}
        />
        <UserModal
          ref={this.saveFormRef}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          confirmLoading={confirmLoading}
          funderCompanys={funders}
          userTypes={userTypes}
          authorities={authorities}
          roles={roles}
          visible={visible}
        />
      </div>
    );
  }
}

ListPage.propTypes = {
  users: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  fetch: PropTypes.func.isRequired,
  create: PropTypes.func.isRequired,
  update: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired,
  roleById: PropTypes.object,
  authorities: PropTypes.array.isRequired,
  query: PropTypes.object.isRequired
};

export default connect(
  state => ({
    users: entitiesSelector('users')(state),
    total: state.users.total,
    query: state.users.query,
    loading: state.users.loading,
    confirmLoading: state.users.confirmLoading,
    visible: state.users.visible,
    roleById: state.entities.roles,
    authorities: state.profile.authorities,
    funders: state.profile.funders,
    userTypes: state.profile.userTypes,
    roles: entitiesSelector('roles')(state)
  }),
  { fetch, create, update, setVisible, fetchRoles }
)(ListPage);
