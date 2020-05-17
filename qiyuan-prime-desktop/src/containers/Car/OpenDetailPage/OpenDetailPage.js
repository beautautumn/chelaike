import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchOne } from 'redux/modules/cars'
import { fetch as fetchStockOutInventory } from 'redux/modules/stockOutInventories'
import { fetch as fetchMaintenance } from 'redux/modules/maintenanceRecords'
import { connectData } from 'decorators'
import Navbar from '../DetailPage/Navbar'
import Digest from '../DetailPage/Details/Digest'
import Basic from '../DetailPage/Details/Basic'
import Sales from '../DetailPage/Details/Sales'
import Customer from '../DetailPage/Details/Customer'
import Mortgage from '../DetailPage/Details/Mortgage'
import Insurance from '../DetailPage/Details/Insurance'
import Features from '../DetailPage/Details/Features'
import PrepareRecord from '../DetailPage/Details/PrepareRecord'
import Licenses from '../DetailPage/Details/Licenses'
import Maitaining from '../DetailPage/Details/Maitaining'
import History from '../DetailPage/Details/History'
import Cost from '../DetailPage/Details/Cost'
import MaintenanceRecord from '../DetailPage/Details/MaintenanceRecord'
import MicroContract from '../DetailPage/Details/MicroContract'
import { Affix, Button } from 'antd'
import styles from '../DetailPage/DetailPage.scss'
import config from 'config'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch, location, params) {
  return Promise.all([
    dispatch(fetchStockOutInventory(params.id)),
    dispatch(fetchOne(params.id)),
  ])
}

@connectData(fetchData)
@connect(
  (state, { params }) => ({
    car: state.entities.cars[params.id],
    stockOutInventory: state.stockOutInventories.currentStockOutInventory,
    transfersById: state.entities.transfers,
    shopsById: state.entities.shops,
    usersById: state.entities.users,
    prepareRecordsById: state.entities.prepareRecords,
    enumValues: state.enumValues,
    currentUser: state.auth.user,
    maintenanceRecord: state.maintenanceRecords.data,
    oss: state.oss,
  }),
  dispatch => ({
    ...bindActionCreators({
      fetchStockOutInventory,
      fetchMaintenance,
    }, dispatch)
  })
)
export default class OpenDetailPage extends Component {
  static propTypes = {
    params: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    stockOutInventory: PropTypes.object,
    transfersById: PropTypes.object,
    shopsById: PropTypes.object,
    usersById: PropTypes.object,
    enumValues: PropTypes.object,
    currentUser: PropTypes.object.isRequired,
    maintenanceRecord: PropTypes.object,
    oss: PropTypes.object.isRequired,
    fetchStockOutInventory: PropTypes.func.isRequired,
    fetchMaintenance: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchMaintenance(this.props.car.id)
  }

  render() {
    const { currentUser, car } = this.props

    return (
      <div className={styles.root}>
        <Helmet title={car.name} />
        <Affix offsetTop={75}>
          <Button type="primary" className={styles.printButton}>
            <a
              href={`${config.serverUrl}/cars/${car.id}/price_tag`}
              target="_blank"
              data-shell-external
            >
              打印价签
            </a>
          </Button>
        </Affix>
        <Digest currentUser={currentUser} {...this.props} />

        <Navbar currentUser={currentUser} car={car} />

        <Basic {...this.props} />
        <Cost {...this.props} />
        <Sales {...this.props} />
        <Customer {...this.props} />
        <MaintenanceRecord {...this.props} />
        <MicroContract {...this.props} />
        <Mortgage {...this.props} />
        <Insurance {...this.props} />
        <Maitaining {...this.props} />
        <Features {...this.props} />
        <PrepareRecord {...this.props} />
        <Licenses {...this.props} />
        <History {...this.props} />
      </div>
    )
  }
}
