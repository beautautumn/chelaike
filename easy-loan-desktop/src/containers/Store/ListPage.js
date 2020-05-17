import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { StoreForm, StoreTable, StoreModal } from 'components';
import {
  fetch as fetchStores,
  create,
  update,
  destory,
  setVisible
} from '../../models/reducers/stores';

import entitiesSelector from '../../utils/entitiesSelector';
import pick from 'lodash/pick';

class ListPage extends React.Component {
  componentDidMount() {
    const debtorId = this.props.match.params.sid;
    this.props.fetchStores({ debtorId: debtorId });
  }

  showModal = record => {
    const form = this.formRef.props.form;
    form.resetFields();
    if (record) {
      const values = pick(record, [
        'id',
        'name',
        'address',
        'userId',
        'debtorId',
        'storeId',
        'longitude',
        'latitude'
      ]);

      /*if (values.address !== null) {
        var result = fetch(
          'http://restapi.amap.com/v3/geocode/geo?key=' +
            MAP_KEY +
            '&address=' +
            `${values.address}`,
          {
            method: 'GET'
          }
        );
        result
          .then(res => {
            return res.json();
          })
          .then(json => {
            console.log(json);
            if (json.geocodes !== null) {
              values.longitude = json.geocodes[0].location.split(',')[0];
              values.latitude = json.geocodes[0].location.split(',')[1];
            }
          });
      }*/
      form.setFieldsValue(values);
      console.log('传给组件的数据', values);
    } else {
      form.setFieldsValue({ storeId: ' ', userId: ' ' });
    }
    this.props.setVisible(true);
  };

  handleQuery = query => {
    const debtorId = this.props.match.params.sid;
    this.props.fetchStores({ page: 1, query, debtorId: debtorId });
  };

  handlePage = page => {
    const debtorId = this.props.match.params.sid;
    this.props.fetchStores({ page, debtorId: debtorId });
  };

  handleCancel = () => {
    this.props.setVisible(false);
  };

  handleOk = () => {
    const form = this.formRef.props.form;
    form.validateFields((err, values) => {
      if (err) {
        return;
      }
      values.storeId = form.getFieldValue('storeId');
      values.debtorId = `${this.props.match.params.sid}`;
      if (values.id) {
        this.props.update(values);
        console.log('store修改', values);
      } else {
        this.props.create(values);
        console.log('store新增', values);
      }
    });
  };

  saveFormRef = formRef => {
    this.formRef = formRef;
  };

  render() {
    const {
      stores,
      loading,
      confirmLoading,
      visible,
      destory,
      query,
      total,
      currentUser,
      assignees,
      inventors,
      update,
      match
    } = this.props;
    if (stores[0]) {
      console.log('stores[0].debtorName', stores[0].debtorName);
    }
    return (
      <div>
        <StoreForm showModal={this.showModal} />
        <StoreTable
          onPageChange={this.handlePage}
          loading={loading}
          update={update}
          destory={destory}
          total={total}
          query={query}
          data={stores}
          currentUser={currentUser}
          showModal={this.showModal}
        />
        <StoreModal
          wrappedComponentRef={this.saveFormRef}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          confirmLoading={confirmLoading}
          assignees={assignees}
          inventors={inventors}
          visible={visible}
          debtorId={match.params.sid}
          stores={stores}
        />
      </div>
    );
  }
}

ListPage.propTypes = {
  stores: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  fetchStores: PropTypes.func.isRequired,
  create: PropTypes.func.isRequired,
  update: PropTypes.func.isRequired,
  destory: PropTypes.func.isRequired,
  setVisible: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired
};

export default connect(
  state => ({
    stores: entitiesSelector('stores')(state),
    total: state.stores.total,
    query: state.stores.query,
    loading: state.stores.loading,
    confirmLoading: state.stores.confirmLoading,
    visible: state.stores.visible,
    currentUser: state.profile.user,
    assignees: state.profile.assignees,
    inventors: state.profile.inventors
  }),
  { fetchStores, create, update, destory, setVisible }
)(ListPage);
