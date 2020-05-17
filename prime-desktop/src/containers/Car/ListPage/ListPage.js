import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { destroy, fetch } from 'redux/modules/cars'
import { update as updateEntity } from 'redux/modules/entities'
import { show as showModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { CarListToolbar } from 'components'
import CarSearchBar from 'containers/CarSearchBar/CarSearchBar'
import List from './List/List'
import Buttons from './Buttons'
import {
  StateEditModal,
  DetectionEditModal,
  PriceEditModal,
  ReserveModal,
  ReservationCancelModal,
  StockOutModal,
  AllianceModal,
} from '..'
import PublisherModal from 'containers/Publisher/PublisherModal/PublisherModal'

const CAR_CRATED_EVENT = 'prime.car.created'
const CAR_UPDATED_EVENT = 'prime.car.updated'

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
    cars: visibleEntitiesSelector('cars')(state, state.cars.inStock.ids),
    total: state.cars.inStock.total,
    query: state.cars.inStock.query,
    end: state.cars.inStock.end,
    shopsById: state.entities.shops,
    usersById: state.entities.users,
    transfersById: state.entities.transfers,
    enumValues: state.enumValues,
    currentUser: state.auth.user
  }),
  dispatch => ({
    ...bindActionCreators({
      destroy,
      updateEntity,
      showModal,
      showNotification,
      fetch
    }, dispatch, 'inStock')
  })
)
export default class ListPage extends Component {
  static propTypes = {
    cars: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    query: PropTypes.object.isRequired,
    end: PropTypes.bool,
    enumValues: PropTypes.object.isRequired,
    transfersById: PropTypes.object,
    shopsById: PropTypes.object,
    usersById: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    destroy: PropTypes.func.isRequired,
    updateEntity: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    fetch: PropTypes.func.isRequired,
    location: PropTypes.object.isRequired
  }

  componentDidMount() {
    window.addEventListener(CAR_CRATED_EVENT, this.handleCreated)
    window.addEventListener(CAR_UPDATED_EVENT, this.handleUpdated)

    const { fetch, query } = this.props
    fetch({ ...defaultQuery, ...query })
  }

  componentWillUnmount() {
    window.removeEventListener(CAR_CRATED_EVENT, this.handleCreated)
    window.removeEventListener(CAR_UPDATED_EVENT, this.handleUpdated)
  }

  handleCreated = () => {
    window.scrollTo(0, 0)

    // 回第一页
    this.props.fetch(defaultQuery)

    this.showNotification()
  }

  handleUpdated = (event) => {
    this.props.updateEntity('cars', event.detail.car.id, event.detail.car)
    this.showNotification()
  }

  showNotification() {
    this.props.showNotification({
      type: 'success',
      message: '保存成功',
    })
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

  handleDestroy = car => () => {
    this.props.destroy(car.id)
  }

  handleShowModal = (modal, id) => event => {
    event.preventDefault()
    this.props.showModal(modal, { id })
  }

  render() {
    const {
      cars,
      total,
      usersById,
      shopsById,
      transfersById,
      enumValues,
      currentUser,
      query
    } = this.props

    return (
      <div>
        <StateEditModal />
        <DetectionEditModal />
        <PriceEditModal />
        <ReservationCancelModal />
        <ReserveModal />
        <StockOutModal />
        <PublisherModal />
        <AllianceModal />

        <Buttons searchQuery={query.query} currentUser={currentUser} />

        <CarSearchBar
          type="CarList"
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
          usersById={usersById}
          shopsById={shopsById}
          transfersById={transfersById}
          currentUser={currentUser}
          handleDestroy={this.handleDestroy}
          handleShowModal={this.handleShowModal}
          handlePage={this.handlePage}
        />
      </div>
    )
  }
}
