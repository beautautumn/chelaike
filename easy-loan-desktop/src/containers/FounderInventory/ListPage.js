import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FInventorySearchForm, FInventoryTable } from 'components';
import { fetch, setVisible } from '../../models/reducers/founderInventory';
import entitiesSelector from '../../utils/entitiesSelector';

class ListPage extends React.Component {
  componentDidMount() {
    this.props.fetch();
  }

  handleQuery = query => {
    this.props.fetch({ page: 1, query });
    console.log('请求的参数是：==========', query);
  };

  handlePage = page => {
    this.props.fetch({ page });
  };

  render() {
    const {
      inventories,
      loading,
      query,
      total,
      assignees,
      inventors
    } = this.props;

    return (
      <div>
        <FInventorySearchForm
          assignees={assignees}
          inventors={inventors}
          onQuery={this.handleQuery}
        />
        <FInventoryTable
          onPageChange={this.handlePage}
          loading={loading}
          total={total}
          query={query}
          data={inventories}
        />
      </div>
    );
  }
}

ListPage.propTypes = {
  inventories: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  fetch: PropTypes.func.isRequired,

  setVisible: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,

  assignees: PropTypes.array.isRequired
};

export default connect(
  state => ({
    inventories: entitiesSelector('founderInventories')(state),
    total: state.inventories.total,
    query: state.inventories.query,
    loading: state.inventories.loading,
    visible: state.inventories.visible,
    assignees: state.profile.assignees,
    inventors: state.profile.inventors
  }),
  { fetch, setVisible }
)(ListPage);
