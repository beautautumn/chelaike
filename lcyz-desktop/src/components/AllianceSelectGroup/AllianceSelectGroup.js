import { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import {
  fetchAlliancesByCompany,
  fetchCompaniesByAlliance,
  fetchShopsByCompany,
} from 'redux/modules/alliances'
import { uniqueId } from 'decorators'

@uniqueId('alliance')
@connect(
  (state, { uniqueId }) => ({
    alliances: state.alliances.data,
    companies: state.alliances.companies[uniqueId],
    shops: state.alliances.shops[uniqueId],
    fetching: state.alliances.fetching,
    fetched: state.alliances.fetched
  }),
  (dispatch) => ({
    ...bindActionCreators({
      fetchAlliancesByCompany,
      fetchCompaniesByAlliance,
      fetchShopsByCompany,
    }, dispatch)
  })
)
export default class AllianceSelectGroup extends Component {
  static propTypes = {
    uniqueId: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    alliances: PropTypes.array.isRequired,
    companies: PropTypes.array,
    shops: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetchAlliancesByCompany: PropTypes.func.isRequired,
    fetchCompaniesByAlliance: PropTypes.func.isRequired,
    fetchShopsByCompany: PropTypes.func.isRequired,
  }

  static childContextTypes = {
    alliances: PropTypes.array.isRequired,
    companies: PropTypes.array,
    shops: PropTypes.array,
    resetCompanies: PropTypes.bool,
    resetShops: PropTypes.bool,
    handleAllianceChange: PropTypes.func.isRequired,
    handleCompanyChange: PropTypes.func.isRequired,
  }

  getChildContext() {
    return {
      alliances: this.props.alliances,
      companies: this.props.companies,
      shops: this.props.shops,
      resetCompanies: this.resetCompanies,
      resetShops: this.resetShops,
      handleAllianceChange: this.handleAllianceChange,
      handleCompanyChange: this.handleCompanyChange,
    }
  }

  componentWillMount() {
    if (!this.props.fetched && !this.props.fetching) {
      this.props.fetchAlliancesByCompany()
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetCompanies = this.props.companies && this.props.companies !== nextProps.companies
    this.resetShops = this.props.shops && this.props.shops !== nextProps.shops
  }

  handleAllianceChange = value => {
    this.props.fetchCompaniesByAlliance(value, this.props.uniqueId)
  }

  handleCompanyChange = value => {
    this.props.fetchShopsByCompany(value, this.props.uniqueId)
  }


  render() {
    return this.props.children
  }
}
