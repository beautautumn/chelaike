import { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch as fetchProvinces } from 'redux/modules/provinces'
import { fetch as fetchCities } from 'redux/modules/cities'
import { uniqueId } from 'decorators'

@uniqueId('region')
@connect(
  (state, { uniqueId }) => ({
    provinces: state.provinces.data,
    cities: state.cities[uniqueId],
    fetching: state.provinces.fetching,
    fetched: state.provinces.fetched,
  }),
  dispatch => ({
    ...bindActionCreators({ fetchProvinces, fetchCities }, dispatch)
  })
)
export default class RegionSelectGroup extends Component {
  static propTypes = {
    uniqueId: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    provinces: PropTypes.array.isRequired,
    cities: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetchProvinces: PropTypes.func.isRequired,
    fetchCities: PropTypes.func.isRequired,
  }

  static childContextTypes = {
    provinces: PropTypes.array.isRequired,
    cities: PropTypes.array,
    resetCities: PropTypes.bool,
    handleProvinceChange: PropTypes.func.isRequired
  }

  getChildContext() {
    return {
      provinces: this.props.provinces,
      cities: this.props.cities,
      resetCities: this.resetCities,
      handleProvinceChange: this.handleProvinceChange
    }
  }

  componentWillMount() {
    if (!this.props.fetched && !this.props.fetching) {
      this.props.fetchProvinces()
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetCities = this.props.cities && this.props.cities !== nextProps.cities
  }

  handleProvinceChange = value => {
    this.props.fetchCities(value, this.props.uniqueId)
  }

  render() {
    return this.props.children
  }
}
