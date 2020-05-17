import { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Province from 'models/province'
import City from 'models/city'
import { uniqueId } from 'decorators'
import * as selects from './selects'

@uniqueId('region')
@connect(
  (_state, { uniqueId }) => ({
    provinces: Province.getState().data,
    cities: City.getState()[uniqueId],
    fetching: Province.getState().fetching,
    fetched: Province.getState().fetched,
  })
)
export default class RegionSelectGroup extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    uniqueId: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    provinces: PropTypes.array.isRequired,
    cities: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
  }

  static childContextTypes = {
    provinces: PropTypes.array.isRequired,
    cities: PropTypes.array,
    resetCities: PropTypes.bool,
    handleProvinceChange: PropTypes.func.isRequired,
  }

  getChildContext() {
    return {
      provinces: this.props.provinces,
      cities: this.props.cities,
      resetCities: this.resetCities,
      handleProvinceChange: this.handleProvinceChange,
    }
  }

  componentWillMount() {
    if (!this.props.fetched && !this.props.fetching) {
      this.props.dispatch(Province.fetch())
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetCities = this.props.cities && this.props.cities !== nextProps.cities
  }

  handleProvinceChange = value => {
    this.props.dispatch(City.fetch(value, this.props.uniqueId))
  }

  render() {
    return this.props.children
  }
}

Object.keys(selects).forEach(name => {
  RegionSelectGroup[name] = selects[name]
})
