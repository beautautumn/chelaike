import React, { PropTypes } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'
import carFactory from 'models/car'
import StockOutInventory from 'models/stockOutInventory'
import MaintenanceRecord from 'models/maintenanceRecord'
import EnumValue from 'models/enumValue'
import Auth from 'models/auth'
import { connectData } from 'decorators'
import * as details from './details'
import NavBar from './NavBar'
import styles from './style.scss'

const Car = carFactory('car::inStock')

function DetailPage(props) {
  const { currentUser, car } = props

  return (
    <div className={styles.root}>
      <details.Digest currentUser={currentUser} {...props} />

      <NavBar currentUser={currentUser} car={car} />

      <details.Basic {...props} />
      <details.Sales {...props} />
      <details.Customer {...props} />
      <details.MaintenanceRecord {...props} />
      <details.Mortgage {...props} />
      <details.Insurance {...props} />
      <details.Maintaining {...props} />
      <details.Features {...props} />
      <details.PrepareRecord {...props} />
      <details.Licenses {...props} />
      <details.History {...props} />
    </div>
  )
}

DetailPage.propTypes = {
  params: PropTypes.object.isRequired,
  car: PropTypes.object.isRequired,
  stockOutInventory: PropTypes.object,
  enumValues: PropTypes.object,
  currentUser: PropTypes.object.isRequired,
  maintenanceRecord: PropTypes.object,
}

function fetchData(getState, dispatch, location, params) {
  return Promise.all([
    dispatch(StockOutInventory.fetch(params.id)),
    dispatch(Car.fetchOne(params.id)),
    dispatch(MaintenanceRecord.fetch(params.id)),
  ])
}

export default compose(
  connectData(fetchData),
  connect(
    (_state, { params }) => ({
      car: Car.select('one', params.id),
      stockOutInventory: StockOutInventory.getState().current,
      enumValues: EnumValue.getState(),
      currentUser: Auth.getState().user,
      maintenanceRecord: MaintenanceRecord.getState().current,
    })
  )
)(DetailPage)
