import { combineReducers } from 'redux'
import { routerReducer, LOCATION_CHANGE } from 'react-router-redux'
import { polymorphicReducer } from 'redux-polymorphic'
import { recycle } from './concerns'
import form from './form'
import auth from './auth'
import entities from './entities'
import users from './users'
import userSelect from './userSelect'
import password from './password'
import roles from './roles'
import shops from './shops'
import channels from './channels'
import enumValues from './enumValues'
import cars from './cars'
import stockOutCars from './stockOutCars'
import licenseCars from './licenseCars'
import prepareRecordCars from './prepareRecordCars'
import carStates from './carStates'
import carPrices from './carPrices'
import carReservations from './carReservations'
import companies from './companies'
import provinces from './provinces'
import cities from './cities'
import districts from './districts'
import oss from './oss'
import warranties from './warranties'
import insuranceCompanies from './insuranceCompanies'
import mortgageCompanies from './mortgageCompanies'
import cooperationCompanies from './cooperationCompanies'
import brands from './brands'
import series from './series'
import styles from './styles'
import stockOutInventories from './stockOutInventories'
import refundInventories from './refundInventories'
import prepareRecords from './prepareRecords'
import transfers from './transfers'
import { reducer as modalReducer, HIDE as HIDE_MODAL } from 'redux-modal'
import serviceAppointments from './serviceAppointments'
import intentions from './intentions'
import intentionLevels from './intentionLevels'
import intentionPushHistories from './intentionPushHistories'
import importTasks from './importTasks'
import location from './location'
import carPublish from './carPublish/reducer'
import carImport from './carImport'
import authorities from './authorities'
import alliances from './alliances'
import weShop from './weShop'
import intentionShares from './intentionShares'
import intentionRecoveryTime from './intentionRecoveryTime'
import maintenanceRecords from './maintenanceRecords'
import statisticsMaintenanceRecords from './statisticsMaintenanceRecords'
import financeConfiguration from './finance/configuration'
import financeSingleCar from './finance/singleCar'
import financeShopFee from './finance/shopFee'
import expirationSettings from './expirationSettings'
import carDetections from './carDetections'
import defeatReasons from './defeatReasons'
import {
    exportSearchForm,
    exportStockReports,
    exportSaleReports,
    exportCustomerReports
  } from './export'

export default combineReducers({
  routing: routerReducer,
  form,
  auth,
  password,
  entities,
  users,
  roles: recycle(LOCATION_CHANGE, roles),
  shops,
  channels,
  enumValues,
  cars: polymorphicReducer({
    inStock: cars,
    inStockSelect: cars
  }),
  carStates,
  carPrices,
  carReservations,
  carDetections,
  stockOutCars,
  licenseCars,
  prepareRecordCars,
  companies,
  oss,
  warranties: recycle(LOCATION_CHANGE, warranties),
  insuranceCompanies: recycle(LOCATION_CHANGE, insuranceCompanies),
  mortgageCompanies: recycle(LOCATION_CHANGE, mortgageCompanies),
  cooperationCompanies: recycle(LOCATION_CHANGE, cooperationCompanies),
  provinces,
  cities,
  districts,
  brands: polymorphicReducer({
    all: brands,
    inStock: recycle(LOCATION_CHANGE, brands),
    outOfStock: recycle(LOCATION_CHANGE, brands)
  }),
  series,
  styles,
  stockOutInventories,
  refundInventories,
  prepareRecords,
  transfers,
  modal: modalReducer,
  serviceAppointments,
  intentions: polymorphicReducer({
    service: intentions,
    following: recycle(HIDE_MODAL, intentions),
    recovery: intentions,
    select: intentions
  }),
  intentionLevels,
  intentionPushHistories,
  importTasks,
  userSelect: polymorphicReducer({
    all: userSelect,
    manager: userSelect,
    acquirer: userSelect,
    seller: userSelect,
    financer: userSelect,
  }),
  location,
  carPublish,
  carImport,
  authorities,
  alliances,
  weShop,
  intentionShares,
  intentionRecoveryTime,
  maintenanceRecords: recycle(LOCATION_CHANGE, maintenanceRecords),
  statisticsMaintenanceRecords,
  financeConfiguration,
  financeSingleCar,
  financeShopFee,
  expirationSettings,
  defeatReasons,
  export: polymorphicReducer({
    searchForm: exportSearchForm,
    stockReports: exportStockReports,
    saleReports: exportSaleReports,
    customerReports: exportCustomerReports
  })
})
