import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetch as fetchCars } from 'redux/modules/cars'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Segment, CarImage, Infinite } from 'components'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import cx from 'classnames'
import styles from './SeekingCarsModal.scss'
import without from 'lodash/without'

@connectModal({ name: 'seekingCarsEdit' })
@connect(
  state => ({
    cars: visibleEntitiesSelector('cars')(state, state.cars.inStockSelect.ids),
    fetchParams: state.cars.inStockSelect.fetchParams,
    fetching: state.cars.inStockSelect.fetching,
    end: state.cars.inStockSelect.end,
  }),
  dispatch => ({
    ...bindActionCreators({
      fetchCars,
    }, dispatch, 'inStockSelect')
  })
)
export default class SeekingCarsModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    cars: PropTypes.array.isRequired,
    fetchParams: PropTypes.object,
    fetching: PropTypes.bool,
    end: PropTypes.bool,
    fetchCars: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    selectedIds: PropTypes.array,
    handleSelect: PropTypes.func.isRequired,
    selection: PropTypes.string.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = {
      selectedIds: props.selectedIds || []
    }
  }

  componentWillMount() {
    const { fetchParams } = this.props

    this.props.fetchCars({
      ...fetchParams,
      query: {},
      page: 1,
      orderBy: 'desc',
      orderField: 'id'
    }, { reset: true })
  }

  handleOk = () => {
    this.props.handleSelect(this.state.selectedIds)
    this.props.handleHide()
  }

  handleScroll = () => {
    const { fetchCars, fetchParams, end } = this.props
    if (!end) {
      fetchCars({ ...fetchParams, page: fetchParams.page + 1 })
    }
  }

  handleSearch = event => {
    const keyword = event.currentTarget.value
    const { fetchCars, fetchParams } = this.props
    fetchCars({
      ...fetchParams,
      query: { nameOrStockNumberOrVinOrCurrentPlateNumberCont: keyword },
      page: 1
    }, { reset: true })
  }

  handleCheck = id => event => {
    const { selectedIds } = this.state
    const { selection } = this.props
    let nextSelectedIds
    if (selection === 'multi' && event.currentTarget.checked) {
      nextSelectedIds = [...selectedIds, id]
    } else if (selection === 'multi' && !event.currentTarget.checked) {
      nextSelectedIds = without(selectedIds, id)
    } else {
      nextSelectedIds = [id]
    }
    this.setState({ selectedIds: nextSelectedIds })
  }

  render() {
    const { cars, fetching, show, handleHide, selection } = this.props
    const { selectedIds } = this.state

    return (
      <Modal
        title="选择车辆"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <div className="content">
          <div className="ui form">
            <div className="ui fluid icon input">
              <input type="text" placeholder="搜索车辆名称／库存号／车架号／车牌号" onChange={this.handleSearch} />
              <i className="search icon"></i>
            </div>
          </div>
          <Segment className={cx('ui segment', styles.carList)}>
            <Infinite onScroll={this.handleScroll} scrollDisabled={fetching} >
              <table className="ui celled selectable striped table center aligned">
                <tbody>
                  {cars.map((car) => (
                    <tr key={car.id}>
                      <td>
                        <div className="ui fitted checkbox">
                          {selection === 'multi' ?
                            <input
                              type="checkbox"
                              checked={selectedIds.includes(car.id)}
                              onChange={this.handleCheck(car.id)}
                            /> :
                            <input
                              type="radio"
                              checked={selectedIds.includes(car.id)}
                              onChange={this.handleCheck(car.id)}
                            />
                          }
                          <label></label>
                        </div>
                      </td>
                      <td>
                        <CarImage car={car} width={100} height={60} />
                      </td>
                      <td>{car.stockNumber}</td>
                      <td>{car.currentPlatNumber}</td>
                      <td className="left aligned">{car.systemName}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </Infinite>
          </Segment>
        </div>
      </Modal>
    )
  }
}
