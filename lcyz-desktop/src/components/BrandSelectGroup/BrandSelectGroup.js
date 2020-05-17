import { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetch as fetchBrands } from 'redux/modules/brands'
import { fetch as fetchSeries } from 'redux/modules/series'
import { fetch as fetchStyles } from 'redux/modules/styles'
import { uniqueId } from 'decorators'

const states = {
  inStock: 'in_stock',
  outOfStock: 'out_of_stock'
}

@uniqueId('brand')
@connect(
  (state, { uniqueId, as }) => ({
    brands: state.brands[as].data,
    series: state.series[uniqueId],
    styles: state.styles[uniqueId],
    fetching: state.brands[as].fetching,
    fetched: state.brands[as].fetched
  }),
  (dispatch, { as }) => ({
    ...bindActionCreators({
      fetchBrands,
      fetchSeries,
      fetchStyles
    }, dispatch, as)
  })
)
export default class BrandSelectGroup extends Component {
  static propTypes = {
    uniqueId: PropTypes.string.isRequired,
    as: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    brands: PropTypes.array.isRequired,
    series: PropTypes.array,
    styles: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetchBrands: PropTypes.func.isRequired,
    fetchSeries: PropTypes.func.isRequired,
    fetchStyles: PropTypes.func.isRequired
  }

  static childContextTypes = {
    as: PropTypes.string.isRequired,
    brands: PropTypes.array.isRequired,
    series: PropTypes.array,
    styles: PropTypes.array,
    resetSeries: PropTypes.bool,
    resetStyles: PropTypes.bool,
    handleBrandChange: PropTypes.func.isRequired,
    handleSeriesChange: PropTypes.func.isRequired
  }

  getChildContext() {
    return {
      as: this.props.as,
      brands: this.props.brands,
      series: this.props.series,
      styles: this.props.styles,
      resetSeries: this.resetSeries,
      resetStyles: this.resetStyles,
      handleBrandChange: this.handleBrandChange,
      handleSeriesChange: this.handleSeriesChange
    }
  }

  componentWillMount() {
    let params
    if (!this.props.fetched && !this.props.fetching) {
      if (this.props.as !== 'all') {
        params = { stateType: states[this.props.as] }
      }
      this.props.fetchBrands(params)
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetSeries = this.props.series && this.props.series !== nextProps.series
    this.resetStyles = this.props.styles && this.props.styles !== nextProps.styles
  }

  handleBrandChange = value => {
    const params = { brand: { name: value } }
    if (this.props.as !== 'all') {
      params.stateType = states[this.props.as]
    }
    this.props.fetchSeries(params, this.props.uniqueId)
  }

  handleSeriesChange = value => {
    this.props.fetchStyles(value, this.props.uniqueId)
  }

  render() {
    return this.props.children
  }
}
