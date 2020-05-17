import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { goBack } from 'react-router-redux'
import carFactory from 'models/car'
import { connectData } from 'decorators'
import Navbar from './NavBar'
import Form from './Form'
import isEmpty from 'lodash/isEmpty'
import styles from './style.scss'

const Car = carFactory('car::inStock')

function fetchData(getState, dispatch, location, params) {
  let promise
  if (params.id) {
    promise = dispatch(Car.fetchEdit(params.id))
  }
  return promise
}

const useableTabsWhenCarIsOutStock = ['basic']

@connectData(fetchData)
@connect(
  (_state, { params }) => ({
    car: Car.select('one', params.id),
    defaultValues: Car.select('defaultValues', params.id),
    saving: Car.getState().saving,
  })
)
export default class EditPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    car: PropTypes.object.isRequired,
    saving: PropTypes.bool,
    params: PropTypes.object,
    location: PropTypes.object.isRequired,
    defaultValues: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)

    const initState = {
      subformStatus: {},
      tab: null,
    }
    this.state = initState
  }

  handleCancel = () => {
    const { dispatch } = this.props
    dispatch(goBack())
  }

  handleSubmit = data => {
    const { dispatch, saving, params } = this.props
    if (saving) return
    if (isEmpty(data.car.allianceMinimunPriceWan)) {
      data.car.allianceMinimunPriceWan = data.car.managerPriceWan
    }
    data.car.licensedAt += '-01'
    data.car.manufacturedAt += '-01'
    data.acquisitionTransfer.compulsoryInsuranceEndAt += '-01'
    data.acquisitionTransfer.annualInspectionEndAt += '-01'
    data.acquisitionTransfer.commercialInsuranceEndAt += '-01'
    if (params.id) {
      dispatch(Car.update(data))
    } else {
      dispatch(Car.create(data))
    }
  }


  markSubformStatus= (status) => {
    const { subformStatus } = this.state
    this.setState({
      ...this.state,
      subformStatus: { ...subformStatus, ...status },
    })
  }

  markActivedTab = (tab) => {
    this.setState({
      ...this.state,
      tab,
    })
  }

  render() {
    const { defaultValues, car } = this.props
    const { subformStatus, tab } = this.state
    const isNewCar = !Boolean(defaultValues.car.id)
    const carIsOutStock = ['acquisition_refunded', 'driven_back', 'sold']
                            .includes(defaultValues.car.state)

    return (
      <div className={styles.container}>
        <Navbar
          tab={tab}
          subformStatus={subformStatus}
          isNewCar={isNewCar}
          carState={defaultValues.car.state}
          useableTabs={carIsOutStock ? useableTabsWhenCarIsOutStock : null}
        />
        <div className={styles.content}>
          <Form
            car={car}
            initialValues={defaultValues}
            onSubmit={this.handleSubmit}
            handleCancel={this.handleCancel}
            markSubformStatus={this.markSubformStatus}
            markActivedTab={this.markActivedTab}
            useableTabs={carIsOutStock ? useableTabsWhenCarIsOutStock : null}
          />
        </div>
      </div>
    )
  }
}

