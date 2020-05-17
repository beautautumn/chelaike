import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import { fetch } from 'redux/modules/prepareRecordCars'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import List from './List/List'
import { CarListToolbar } from 'components'
import CarSearchBar from 'containers/CarSearchBar/CarSearchBar'
import { EditModal } from '..'
import Helmet from 'react-helmet'

const sortableFields = [
  { key: 'acquired_at', name: '收购日期' },
  { key: 'id', name: '库龄' },
  { key: 'show_price_cents', name: '价格' },
  { key: 'age', name: '车龄' },
  { key: 'mileage', name: '里程' }
]

const defaultQuery = {
  query: {},
  page: 1,
  orderBy: 'desc',
  orderField: 'acquired_at',
}

@connect(
  state => ({
    cars: visibleEntitiesSelector('cars')(state, state.prepareRecordCars.ids),
    total: state.prepareRecordCars.total,
    transfersById: state.entities.transfers,
    shopsById: state.entities.shops,
    usersById: state.entities.users,
    prepareRecordsById: state.entities.prepareRecords,
    enumValues: state.enumValues,
    query: state.prepareRecordCars.query,
    end: state.prepareRecordCars.end,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      showModal
    }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    cars: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    enumValues: PropTypes.object.isRequired,
    transfersById: PropTypes.object,
    shopsById: PropTypes.object,
    usersById: PropTypes.object,
    prepareRecordsById: PropTypes.object,
    fetch: PropTypes.func.isRequired,
    query: PropTypes.object.isRequired,
    end: PropTypes.bool,
    currentUser: PropTypes.object.isRequired,
    showModal: PropTypes.func.isRequired,
    location: PropTypes.object.isRequired
  }

  componentDidMount() {
    const { fetch, query } = this.props
    fetch({ ...defaultQuery, ...query })
  }

  handleSort = (sort) => () => {
    const { query } = this.props
    this.props.fetch({ ...query, ...sort })
  }

  handleSearch = searchQuery => {
    const { query } = this.props
    if (searchQuery && searchQuery.prepareRecordStateEq === 'unPrepare') {
      delete searchQuery.prepareRecordStateEq
      searchQuery.prepareRecordStateNull = 1
    }
    this.props.fetch({ ...query, query: searchQuery, page: 1 })
  }

  handlePage = page => {
    const { query } = this.props
    this.props.fetch({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  handleShowModal = (modal, id) => event => {
    event.preventDefault()
    this.props.showModal(modal, { id })
  }

  render() {
    const {
      cars,
      total,
      enumValues,
      transfersById,
      shopsById,
      usersById,
      prepareRecordsById,
      currentUser,
      query
    } = this.props

    return (
      <div>
        <Helmet title="整备管理" />
        <EditModal />

        <CarSearchBar
          type="PrepareRecordList"
          defaultQuery={query.query}
          onSearch={this.handleSearch}
        />

        <CarListToolbar
          total={total}
          fields={sortableFields}
          query={query}
          onSort={this.handleSort}
        />

        <List
          total={total}
          query={query}
          enumValues={enumValues}
          cars={cars}
          transfersById={transfersById}
          usersById={usersById}
          shopsById={shopsById}
          prepareRecordsById={prepareRecordsById}
          currentUser={currentUser}
          handleShowModal={this.handleShowModal}
          handlePage={this.handlePage}
        />
      </div>
    )
  }
}
