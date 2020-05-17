import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/stockOutCars'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { visibleCarStatesSelector } from 'redux/selectors/enumValues'
import { CarListToolbar } from 'components'
import CarSearchBar from 'containers/CarSearchBar/CarSearchBar'
import List from './List/List'
import Buttons from './Buttons'
import * as Car from 'containers/Car'
import * as License from 'containers/License'
import * as PrepareRecord from 'containers/PrepareRecord'
import Helmet from 'react-helmet'

const sortableFields = [
  { key: 'stock_out_at', name: '出库日期' },
  { key: 'show_price_cents', name: '价格' },
  { key: 'stock_age_days', name: '库龄' },
  { key: 'age', name: '车龄' },
]

const defaultQuery = {
  query: {},
  page: 1,
  orderBy: 'desc',
  orderField: 'stock_out_at'
}

@connect(
  state => ({
    cars: visibleEntitiesSelector('cars')(state, state.stockOutCars.ids),
    total: state.stockOutCars.total,
    transfersById: state.entities.transfers,
    shopsById: state.entities.shops,
    usersById: state.entities.users,
    enumValues: state.enumValues,
    query: state.stockOutCars.query,
    end: state.stockOutCars.end,
    currentUser: state.auth.user,
    ...visibleCarStatesSelector(state)
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
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    query: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    end: PropTypes.bool,
    stockOutCarStates: PropTypes.object.isRequired,
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
    this.props.fetch({ ...query, query: searchQuery, page: 1 })
  }

  handlePage = page => {
    const { query } = this.props
    this.props.fetch({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  handleShowModal = (modal, props) => event => {
    event.preventDefault()
    this.props.showModal(modal, props)
  }

  render() {
    const {
      cars,
      total,
      enumValues,
      transfersById,
      shopsById,
      usersById,
      currentUser,
      query,
    } = this.props

    return (
      <div>
        <Helmet title="出库车辆" />
        <Car.StockOutModal />
        <Car.RefundModal />
        <License.EditModal />
        <PrepareRecord.EditModal />

        <Buttons searchQuery={query.query} currentUser={currentUser} />

        <CarSearchBar
          type="StockOutCarList"
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
          currentUser={currentUser}
          handleShowModal={this.handleShowModal}
          handlePage={this.handlePage}
        />
      </div>
    )
  }
}
