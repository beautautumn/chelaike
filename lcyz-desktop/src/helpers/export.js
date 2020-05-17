import { bindActionCreators } from 'redux'
import { fetchCities, fetchShops, fetchCompanies, fetchUsers } from 'redux/modules/export'

export const mapSearchFormStateToProps = (state) => {
  const { searchForm: { cities, shops, companies, users } } = state.export
  return {
    cities,
    shops,
    companies,
    users
  }
}

export const mapSearchFormDispatchToProps = (dispatch) => ({
  ...bindActionCreators({
    fetchCities,
    fetchShops,
    fetchCompanies,
    fetchUsers
  }, dispatch)
})
