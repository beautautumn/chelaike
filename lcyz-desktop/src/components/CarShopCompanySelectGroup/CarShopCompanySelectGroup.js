import { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { fetch as fetchShops } from 'redux/modules/shops'
import { fetch as fetchCompanies } from 'redux/modules/cooperationCompanies'

@connect(
  (state) => ({
    shops: visibleEntitiesSelector('shops')(state),
    companies: visibleEntitiesSelector('cooperationCompanies')(state),
    fetching: state.shops.fetching,
    fetched: state.shops.fetched,
  }),
  dispatch => ({
    ...bindActionCreators({ fetchShops, fetchCompanies }, dispatch)
  })
)
export default class CarShopCompanySelectGroup extends Component {
  static propTypes = {
    children: PropTypes.element.isRequired,
    shops: PropTypes.array.isRequired,
    companies: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetchShops: PropTypes.func.isRequired,
    fetchCompanies: PropTypes.func.isRequired,
  }

  static childContextTypes = {
    shops: PropTypes.array.isRequired,
    companies: PropTypes.array,
    resetCompanies: PropTypes.bool,
    handleShopChange: PropTypes.func.isRequired
  }

  getChildContext() {
    return {
      shops: this.props.shops,
      companies: this.props.companies,
      resetCompanies: this.resetCompanies,
      handleShopChange: this.handleShopChange
    }
  }

  componentWillMount() {
    if (!this.props.fetched && !this.props.fetching) {
      this.props.fetchShops()
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetCompanies = this.props.companies.length > 0 &&
      this.props.companies !== nextProps.companies
  }

  handleShopChange = value => {
    this.props.fetchCompanies({ 'query[shop_id_eq]': value })
  }

  render() {
    return this.props.children
  }
}
