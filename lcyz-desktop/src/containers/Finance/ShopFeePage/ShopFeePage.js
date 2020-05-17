import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch, update } from 'redux/modules/finance/shopFee'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import config from 'config'
import { decamelizeKeys } from 'humps'
import Helmet from 'react-helmet'
import ToolBar from './ToolBar/ToolBar'
import List from './List/List'
import qs from 'qs'

@connect(
  state => ({
    query: state.financeShopFee.query,
    total: state.financeShopFee.total,
    shopFees: visibleEntitiesSelector('financeShopFee')(state),
    currentUser: state.auth.user,
  }),
  {
    fetch,
    update,
  }
)
export default class ShopFeePage extends Component {
  static propTypes = {
    query: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    shopFees: PropTypes.array.isRequired,
    currentUser: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.defautQuery = {
      query: {
        shopId: props.currentUser.shopId
      },
      page: 1,
      orderBy: 'desc',
      orderField: 'acquired_at',
    }

    this.state = {
      shopFees: props.shopFees.reduce(
        (acc, shopFee) => ({ ...acc, [shopFee.id]: shopFee }),
        {}
      )
    }
  }

  componentWillMount() {
    const { fetch } = this.props
    fetch(this.defautQuery)
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.shopFees !== nextProps.shopFees) {
      this.setState({
        shopFees: nextProps.shopFees.reduce(
          (acc, shopFee) => ({ ...acc, [shopFee.id]: shopFee }),
          {}
        )
      })
    }
  }

  handleChange = (id, field) => e => {
    const { shopFees } = this.state

    const next = {
      ...shopFees,
      [id]: {
        ...shopFees[id],
        [field]: e.target.value
      }
    }

    this.setState({ shopFees: next })
  }

  handleSubmit = id => () => {
    this.props.update(this.state.shopFees[id])
  }

  handleSearch = value => {
    const { fetch, query } = this.props
    fetch({ ...query, query: { shopId: value } })
  }

  handleExport = () => {
    const { query, currentUser } = this.props
    const queryObj = {
      AutobotsToken: currentUser.token,
    }
    if (query && query.query) queryObj.query = decamelizeKeys(query.query)
    const queryString = qs.stringify(queryObj, { arrayFormat: 'brackets' })
    window.location.href =
      `${config.serverUrl}${config.basePath}/finance/shop_fees/export?${queryString}`
  }

  render() {
    const { query } = this.props
    const shopFees = Object.values(this.state.shopFees)
                           .sort((a, b) => (b.month.localeCompare(a.month)))

    return (
      <div>
        <Helmet title="运营成本与收益" />

        <ToolBar
          searchQuery={query.query}
          handleSearch={this.handleSearch}
          handleExport={this.handleExport}
        />

        <List
          shopFees={shopFees}
          handleChange={this.handleChange}
          handleSubmit={this.handleSubmit}
        />
      </div>
    )
  }
}
