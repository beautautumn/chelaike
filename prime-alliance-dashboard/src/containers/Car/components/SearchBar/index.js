import React, { Component, PropTypes } from 'react'
import * as filters from './filters'
import { isBlank } from 'utils'
import { Row, Col } from 'antd'
import map from 'lodash/map'
import debounce from 'lodash/debounce'
import can from 'helpers/can'
import { Segment, Datepicker } from 'components'
import Keyword from './Keyword'
import Brand from './Brand'
import Acquisition from './Acquisition'
import StockOut from './StockOut'
import Operation from './Operation'
import Transfer from './Transfer'
import PrepareRecord from './PrepareRecord'
import Tags from './Tags'
import styles from './style.scss'

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

export default class SearchBar extends Component {
  static propTypes = {
    defaultQuery: PropTypes.object,
    onSearch: PropTypes.func.isRequired,
    type: PropTypes.string.isRequired,
    enumValues: PropTypes.object.isRequired,
    inStockCarStates: PropTypes.object.isRequired,
    stockOutCarStates: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)

    const query = props.defaultQuery ? denormalizeQuery(props.defaultQuery) : {}

    this.state = {
      advanced: false,
      query,
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
      inStockCarStates,
      stockOutCarStates,
    } = this.props

    const { query, advanced } = this.state

    const carStates = type === 'StockOutCarList' ? stockOutCarStates : inStockCarStates

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

                {advanced && (
                  <Tags
                    query={query}
                    label="预定状态"
                    filters={filters.reserved}
                    keys={['reservedEq']}
                    handleClick={this.handleClick}
                  >
                    <Datepicker
                      size="default"
                      placeholder="预订日期"
                      value={query.reservedOn}
                      onChange={this.handleChange('reservedOn')}
                      style={{ verticalAlign: 'middle' }}
                    />
                  </Tags>
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
                    label="车辆状态"
                    filters={map(carStates, (text, value) => [value, undefined, text])}
                    keys={['stateEq']}
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

                {advanced && type === 'CarList' && (
                  <Operation
                    query={query}
                    enumValues={enumValues}
                    keys={['operationRecordsCreatedAtGteq', 'operationRecordsCreatedAtLteq']}
                    handleChange={this.handleChange}
                  />
                )}
                {advanced && type === 'CarList' && (
                  <Tags
                    query={query}
                    label="操作类型"
                    filters={
                      map(enumValues.operation_record.car_operation_type,
                        (text, value) => [value, undefined, text])
                    }
                    keys={['operationRecordsOperationRecordTypeEq']}
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
