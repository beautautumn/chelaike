import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { connectModal } from 'redux-modal'
import carFactory from 'models/car'
import { Modal } from 'antd'
import List from './List'
import debounce from 'lodash/debounce'

const Car = carFactory('car::inStock')

const defaultQuery = {
  query: {},
  page: 1,
  perPage: 5,
  orderBy: 'desc',
  orderField: 'acquired_at',
}

@connectModal({ name: 'carList' })
@connect(
  _state => ({
    cars: Car.select('list'),
    query: Car.getState().query,
    total: Car.getState().total,
  })
)
export default class ListModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    cars: PropTypes.array.isRequired,
    query: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    selectedIds: PropTypes.array,
    handleHide: PropTypes.func.isRequired,
    handleSelect: PropTypes.func.isRequired,
    type: PropTypes.string,
  }

  constructor(props) {
    super(props)

    this.state = {
      selectedIds: props.selectedIds || [],
      query: props.query,
    }

    this.onSearch = debounce(searchQuery => {
      const { dispatch } = this.props
      const { query } = this.state
      dispatch(
        Car.fetch({
          ...defaultQuery,
          ...query,
          ...searchQuery,
        })
      )
    }, 300)
  }

  componentWillMount() {
    this.handleSearch({})
  }

  handleSelect = ids => {
    this.setState({ selectedIds: ids })
  }

  handleOk = () => {
    this.props.handleSelect(this.state.selectedIds)
    this.props.handleHide()
  }

  handleSearch = query => {
    this.setState({ query })
    this.onSearch(query)
  }

  handlePage = page => {
    const { query } = this.state
    this.handleSearch({ ...query, page })
  }

  handleChange = event => {
    const value = event.currentTarget ? event.currentTarget.value : event
    this.handleSearch({ query: { nameOrStockNumberOrVinOrCurrentPlateNumberCont: value }, page: 1 })
  }

  render() {
    const { selectedIds } = this.state
    const { show, handleHide, cars, type, total } = this.props
    const { query } = this.state

    return (
      <Modal
        title="选择车辆"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <List
          type={type}
          cars={cars}
          selectedIds={selectedIds}
          handleSearch={this.handleChange}
          handleSelect={this.handleSelect}
          handlePage={this.handlePage}
          query={query}
          total={total}
        />
      </Modal>
    )
  }
}
