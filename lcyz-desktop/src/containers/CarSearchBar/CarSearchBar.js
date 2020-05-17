import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { visibleCarStatesSelector } from 'redux/selectors/enumValues'
import * as filters from './filters'
import Keyword from './Filters/Keyword'
import Brand from './Filters/Brand'
import Acquisition from './Filters/Acquisition'
import StockOut from './Filters/StockOut'
import Transfer from './Filters/Transfer'
import PrepareRecord from './Filters/PrepareRecord'
import Tags from './Filters/Tags'
import styles from './CarSearchBar.scss'
import isBlank from 'utils/isBlank'
import { Segment } from 'components'
import { Row, Col } from 'antd'
import map from 'lodash/map'
import debounce from 'lodash/debounce'
import can from 'helpers/can'

function normalizeQuery(query) {
  return Object.keys(query).reduce((acc, key) => {
    const value = query[key]
    if (isBlank(value)) {
      return acc
    }

    if (key.includes('Cents')) {
      acc[key] = value * 1000000
      return acc
    }

    if (['ageGteq', 'ageLteq'].includes(key)) {
      acc[key] = value * 365
      return acc
    }
    acc[key] = value
    return acc
  }, {})
}

function denormalizeQuery(query) {
  return Object.keys(query).reduce((acc, key) => {
    const value = query[key]
    if (isBlank(value)) {
      return acc
    }

    if (key.includes('Cents')) {
      acc[key] = value / 1000000
      return acc
    }

    if (['ageGteq', 'ageLteq'].includes(key)) {
      acc[key] = value / 365
      return acc
    }
    acc[key] = value
    return acc
  }, {})
}

@connect(
  state => ({
    shopsById: state.entities.shops,
    usersById: state.entities.users,
    enumValues: state.enumValues,
    ...visibleCarStatesSelector(state)
  })
)
export default class CarSearchBar extends Component {
  static propTypes = {
    defaultQuery: PropTypes.object,
    onSearch: PropTypes.func.isRequired,
    type: PropTypes.string.isRequired,
    usersById: PropTypes.object,
    shopsById: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
    inHallCarStates: PropTypes.object.isRequired,
    stockOutCarStates: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props)

    const query = props.defaultQuery ? denormalizeQuery(props.defaultQuery) : {}

    this.state = {
      advanced: false,
      query
    }

    this.onSearch = debounce(props.onSearch, 300)
  }

  handleChange = field => event => {
    const value = event.currentTarget ? event.currentTarget.value : event
    this.handleSearch({ ...this.state.query, [field]: value })
  }

  handleClick = query => event => {
    if (event) event.preventDefault()
    this.handleSearch({ ...this.state.query, ...query })
  }

  handleClear = event => {
    event.preventDefault()
    this.handleSearch({})
  }

  handleToggle = event => {
    event.preventDefault()
    this.setState({ advanced: !this.state.advanced })
  }

  handleSearch(query) {
    this.setState({ query })
    this.onSearch(normalizeQuery(query))
  }

  render() {
    const {
      type,
      enumValues,
    } = this.props

    const { query, advanced } = this.state

    return (
      <Segment className={styles.carSearchBar}>
        <Keyword
          query={query}
          advanced={advanced}
          handleChange={this.handleChange}
          handleToggle={this.handleToggle}
          handleClear={this.handleClear}
        />

        <Row className={styles.row}>
          <Col>
            <table className={styles.table}>
              <tbody>
                <Brand
                  query={query}
                  handleChange={this.handleChange}
                  type={type}
                />

                {advanced &&
                 can('收购信息查看') && (
                  <Acquisition
                    query={query}
                    advanced={advanced}
                    enumValues={enumValues}
                    handleChange={this.handleChange}
                  />
                )}

                {advanced && type === 'StockOutCarList' && (
                  <StockOut
                    query={query}
                    enumValues={enumValues}
                    handleChange={this.handleChange}
                  />
                )}

                {advanced && type === 'LicenseList' && (
                  <Transfer
                    query={query}
                    enumValues={enumValues}
                    handleChange={this.handleChange}
                  />
                )}

                {advanced && type === 'PrepareRecordList' && (
                  <PrepareRecord
                    query={query}
                    enumValues={enumValues}
                    handleChange={this.handleChange}
                  />
                )}

                {advanced && type !== 'StockOutCarList' && (
                  <Tags
                    query={query}
                    label="预定状态"
                    filters={filters.reserved}
                    keys={['reservedEq']}
                    handleClick={this.handleClick}
                  />
                )}

                {advanced && (
                  <Tags
                    query={query}
                    label="车辆等级"
                    filters={filters.carLevel}
                    keys={['levelEq']}
                    handleClick={this.handleClick}
                  />
                )}

                {advanced && (
                  <Tags
                    query={query}
                    label="车身类型"
                    filters={map(enumValues.car.car_type, (text, value) =>
                                 [value, undefined, text])}
                    keys={['carTypeEq']}
                    handleClick={this.handleClick}
                  />
                )}

                <Tags
                  query={query}
                  label="展厅价"
                  filters={filters.showPrice}
                  keys={['showPriceCentsGteq', 'showPriceCentsLteq']}
                  handleClick={this.handleClick}
                  customInput
                  unit="万元"
                />

                {advanced && (
                  <Tags
                    query={query}
                    label="库龄"
                    filters={filters.stockAge}
                    keys={['stockAgeDaysGteq', 'stockAgeDaysLteq']}
                    handleClick={this.handleClick}
                    customInput
                    unit="天"
                  />
                )}

                {advanced && (
                  <Tags
                    query={query}
                    label="车龄"
                    filters={filters.carAge}
                    keys={['ageGteq', 'ageLteq']}
                    handleClick={this.handleClick}
                    customInput
                    unit="年"
                  />
                )}

                {advanced && (
                  <Tags
                    query={query}
                    label="里程"
                    filters={filters.mileage}
                    keys={['mileageGteq', 'mileageLteq']}
                    handleClick={this.handleClick}
                    customInput
                    unit="万公里"
                  />
                )}

                {advanced && (
                  <Tags
                    query={query}
                    label="排量"
                    filters={filters.displacement}
                    keys={['displacementGteq', 'displacementLteq']}
                    handleClick={this.handleClick}
                  />
                )}
              </tbody>
            </table>
          </Col>
        </Row>
      </Segment>
    )
  }
}
