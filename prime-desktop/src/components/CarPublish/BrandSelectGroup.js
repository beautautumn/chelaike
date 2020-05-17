import { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetchBrands, fetchSeries, fetchStyles, reset } from 'redux/modules/carPublish/selects'

@connect(
  (state, { as }) => ({
    brands: state.carPublish.selects[as].brands,
    series: state.carPublish.selects[as].series,
    styles: state.carPublish.selects[as].styles,
    fetching: state.carPublish.selects[as].fetching,
    fetched: state.carPublish.selects[as].fetched
  }),
  (dispatch, { as }) => ({
    ...bindActionCreators({
      fetchBrands,
      fetchSeries,
      fetchStyles,
      reset,
    }, dispatch, as)
  })
)
export default class BrandSelectGroup extends Component {
  static propTypes = {
    as: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    brands: PropTypes.array,
    series: PropTypes.array,
    styles: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetchBrands: PropTypes.func.isRequired,
    fetchSeries: PropTypes.func.isRequired,
    fetchStyles: PropTypes.func.isRequired,
    reset: PropTypes.func.isRequired,
  }

  static childContextTypes = {
    as: PropTypes.string.isRequired,
    brands: PropTypes.array,
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
    if (!this.props.fetched && !this.props.fetching) {
      const params = { platform: this.props.as }
      this.props.fetchBrands(params)
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetSeries = this.props.series && this.props.series !== nextProps.series
    this.resetStyles = this.props.styles && this.props.styles !== nextProps.styles
  }

  componentWillUnmount() {
    this.props.reset()
  }

  handleBrandChange = value => {
    const params = {
      platform: this.props.as,
      brandId: value
    }
    this.props.fetchSeries(params)
  }

  handleSeriesChange = value => {
    const params = {
      platform: this.props.as,
      seriesId: value
    }
    this.props.fetchStyles(params)
  }

  render() {
    return this.props.children
  }
}
