import { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import brandFactory from 'models/brand'
import Series from 'models/series'
import Style from 'models/style'
import { uniqueId } from 'decorators'
import * as selects from './selects'

let Brand = null

const states = {
  inStock: 'in_stock',
  outOfStock: 'out_of_stock',
}

@uniqueId('brand')
@connect(
  (_state, { uniqueId, as }) => {
    Brand = brandFactory(`brand::${as}`)

    return {
      brands: Brand.getState().data,
      series: Series.getState()[uniqueId],
      styles: Style.getState()[uniqueId],
      fetching: Brand.getState().fetching,
      fetched: Brand.getState().fetched,
    }
  }
)
export default class BrandSelectGroup extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    uniqueId: PropTypes.string.isRequired,
    as: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    brands: PropTypes.array.isRequired,
    series: PropTypes.array,
    styles: PropTypes.array,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
  }

  static childContextTypes = {
    as: PropTypes.string.isRequired,
    brands: PropTypes.array.isRequired,
    series: PropTypes.array,
    styles: PropTypes.array,
    resetSeries: PropTypes.bool,
    resetStyles: PropTypes.bool,
    handleBrandChange: PropTypes.func.isRequired,
    handleSeriesChange: PropTypes.func.isRequired,
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
      handleSeriesChange: this.handleSeriesChange,
    }
  }

  componentWillMount() {
    let params
    if (!this.props.fetched && !this.props.fetching) {
      if (this.props.as !== 'all') {
        params = { stateType: states[this.props.as] }
      }
      this.props.dispatch(Brand.fetch(params))
    }
  }

  componentWillReceiveProps(nextProps) {
    this.resetSeries = this.props.series &&
                       this.props.series.length > 0 &&
                       this.props.series !== nextProps.series
    this.resetStyles = this.props.styles &&
                       this.props.styles.length > 0 &&
                       this.props.styles !== nextProps.styles
  }

  handleBrandChange = value => {
    const params = { brand: { name: value } }
    if (this.props.as !== 'all') {
      params.stateType = states[this.props.as]
    }
    this.props.dispatch(Series.fetch(params, this.props.uniqueId))
  }

  handleSeriesChange = value => {
    this.props.dispatch(Style.fetch(value, this.props.uniqueId))
  }

  render() {
    return this.props.children
  }
}

Object.keys(selects).forEach(name => {
  BrandSelectGroup[name] = selects[name]
})
