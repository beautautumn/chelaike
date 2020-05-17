import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import {
  fetch,
  setVisible
} from '../../models/reducers/founderInventoryDetail';
import entitiesSelector from '../../utils/entitiesSelector';
import FDetailTable from '../../components/FounderInventoryDetail/FInventoryDetailTable';

class ListPage extends React.Component {
  componentDidMount() {
    const id = this.props.match.params.cid;
    this.props.fetch({ id: id });
  }

  render() {
    const { inventories, loading } = this.props;
    console.log('inventories', inventories);
    return (
      <div>
        <FDetailTable loading={loading} data={inventories} />
      </div>
    );
  }
}

ListPage.propTypes = {
  inventories: PropTypes.array.isRequired,
  fetch: PropTypes.func.isRequired,

  setVisible: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired
};

export default connect(
  state => ({
    inventories: entitiesSelector('founderInventoryDetails')(state),
    total: state.inventories.total,
    query: state.inventories.query,
    loading: state.inventories.loading,
    visible: state.inventories.visible
  }),
  { fetch, setVisible }
)(ListPage);
