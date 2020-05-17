import React, { Component, PropTypes } from 'react'
import { connect } from 'feeble/redux'
import { show as showModal } from 'redux-modal'
import carFactory from 'models/car'
import EnumValue from 'models/enumValue'
import Auth from 'models/auth'
import { SearchBar, ToolBar } from '../components'
import List from './List'
import Helmet from 'react-helmet'
import { ImageUploadModal } from '../'
import { PAGE_SIZE } from 'config/constants'

const Car = carFactory('car::inStock')

const sortableFields = [
  { key: 'acquired_at', name: '收购日期' },
  { key: 'id', name: '库龄' },
  { key: 'show_price_cents', name: '价格' },
  { key: 'age', name: '车龄' },
  { key: 'mileage', name: '里程' },
]

const defaultQuery = {
  query: {},
  perPage: PAGE_SIZE,
  page: 1,
  orderBy: 'desc',
  orderField: 'acquired_at',
}

@connect(
  _state => ({
    cars: Car.select('list'),
    total: Car.getState().total,
    query: Car.getState().query,
    enumValues: EnumValue.getState(),
    currentUser: Auth.getState().user,
    ...EnumValue.select('carStates'),
  })
)
export default class InStockListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    cars: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    query: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    inStockCarStates: PropTypes.object.isRequired,
    stockOutCarStates: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
  }

  componentWillMount() {
    const { dispatch, query } = this.props
    dispatch(Car.fetch({ ...defaultQuery, ...query }))
  }

  handleSort = (sort) => () => {
    const { dispatch, query } = this.props
    dispatch(Car.fetch({ ...query, ...sort }))
  }

  handleSearch = searchQuery => {
    const { dispatch, query } = this.props
    dispatch(Car.fetch({ ...query, query: searchQuery, page: 1 }))
  }

  handlePage = page => {
    const { dispatch, query } = this.props
    dispatch(Car.fetch({ ...query, page }))
  }

  handleImageUpload = id => event => {
    event.preventDefault()
    const { dispatch } = this.props
    dispatch(showModal('carImageUpload', { id }))
  }

  render() {
    const {
      cars,
      total,
      enumValues,
      inStockCarStates,
      stockOutCarStates,
      currentUser,
      query,
    } = this.props

    return (
      <div>
        <Helmet title="在库车辆" />

        <ImageUploadModal />

        <SearchBar
          type="CarList"
          enumValues={enumValues}
          inStockCarStates={inStockCarStates}
          stockOutCarStates={stockOutCarStates}
          defaultQuery={query.query}
          onSearch={this.handleSearch}
        />

        <ToolBar
          total={total}
          fields={sortableFields}
          query={query}
          currentUser={currentUser}
          handleSort={this.handleSort}
        />

        <List
          total={total}
          query={query}
          enumValues={enumValues}
          cars={cars}
          currentUser={currentUser}
          handlePage={this.handlePage}
          handleImageUpload={this.handleImageUpload}
        />
      </div>
    )
  }
}
