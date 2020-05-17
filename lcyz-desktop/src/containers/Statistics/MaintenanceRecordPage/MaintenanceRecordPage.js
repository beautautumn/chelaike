import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/statisticsMaintenanceRecords'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import SearchBar from './SearchBar/SearchBar'
import ToolBar from './ToolBar/ToolBar'
import List from './List/List'

@connect(
  state => ({
    fetchParams: state.statisticsMaintenanceRecords.fetchParams,
    total: state.statisticsMaintenanceRecords.total,
    storedCount: state.statisticsMaintenanceRecords.storedCount,
    fetching: state.statisticsMaintenanceRecords.fetching,
    currentUser: state.auth.user,
    maintenanceRecords: visibleEntitiesSelector('statisticsMaintenanceRecords')(state),
  }),
  { fetch }
)
export default class MaintenanceRecordPage extends Component {
  static propTypes = {
    fetchParams: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    storedCount: PropTypes.number.isRequired,
    currentUser: PropTypes.object.isRequired,
    maintenanceRecords: PropTypes.array.isRequired,
    fetching: PropTypes.bool,
    fetch: PropTypes.func.isRequired,
  }

  render() {
    const {
      fetchParams, total, storedCount, currentUser,
      maintenanceRecords, fetching, fetch,
    } = this.props

    return (
      <div>
        <SearchBar fetchParams={fetchParams} fetch={fetch} />
        <ToolBar
          total={total}
          storedCount={storedCount}
          currentUser={currentUser}
          fetchParams={fetchParams}
        />
        <List
          fetchParams={fetchParams}
          fetch={fetch}
          maintenanceRecords={maintenanceRecords}
          fetching={fetching}
          total={total}
        />
      </div>
    )
  }
}
