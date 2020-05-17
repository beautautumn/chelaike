import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import carFactory from 'models/car'
import Auth from 'models/auth'
import EnumValue from 'models/enumValue'
import { SearchBar, ToolBar } from '../components'
import List from './List'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'config/constants'

const Car = carFactory('car::stockOut')

const sortableFields = [
  { key: 'stock_out_at', name: '出库日期' },
  { key: 'show_price_cents', name: '价格' },
  { key: 'stock_age_days', name: '库龄' },
  { key: 'age', name: '车龄' },
]

const defaultQuery = {
  query: {},
  perPage: PAGE_SIZE,
  page: 1,
  orderBy: 'desc',
  orderField: 'stock_out_at',
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
export default class ListPage extends Component {
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

  componentDidMount() {
    const { dispatch, query } = this.props
    dispatch(Car.fetch({ ...defaultQuery, ...query }))
  }

  handleSort = sort => () => {
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
        <Helmet title="出库车辆" />

        <SearchBar
          type="StockOutCarList"
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
          handleSort={this.handleSort}
          currentUser={currentUser}
        />

        <List
          total={total}
          query={query}
          enumValues={enumValues}
          cars={cars}
          currentUser={currentUser}
          handlePage={this.handlePage}
        />
      </div>
    )
  }
}
