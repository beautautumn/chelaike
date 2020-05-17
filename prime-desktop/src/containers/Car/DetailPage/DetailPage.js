import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchOne } from 'redux/modules/cars'
import { fetch as fetchStockOutInventory } from 'redux/modules/stockOutInventories'
import { fetch as fetchMaintenance } from 'redux/modules/maintenanceRecords'
import { connectData } from 'decorators'
import can, { canCrossShop } from 'helpers/can'
import Navbar from './Navbar'
import Digest from './Details/Digest'
import Basic from './Details/Basic'
import Sales from './Details/Sales'
import Customer from './Details/Customer'
import Mortgage from './Details/Mortgage'
import Insurance from './Details/Insurance'
import Features from './Details/Features'
import PrepareRecord from './Details/PrepareRecord'
import Licenses from './Details/Licenses'
import Maitaining from './Details/Maitaining'
import History from './Details/History'
import Cost from './Details/Cost'
import MaintenanceRecord from './Details/MaintenanceRecord'
import MicroContract from './Details/MicroContract'
import { Affix, Button } from 'antd'
import styles from './DetailPage.scss'
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
export default class DetailPage extends Component {
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
        {can('收购价格查看', null, car.shopId) && <Cost {...this.props} />}
        <Sales {...this.props} />
        {canCrossShop(car.shop) && <Customer {...this.props} />}
        {can('维保详情查看', null, car.shopId) && <MaintenanceRecord {...this.props} />}
        {canCrossShop(car.shop) && <MicroContract {...this.props} />}
        {canCrossShop(car.shop) && <Mortgage {...this.props} />}
        {canCrossShop(car.shop) && <Insurance {...this.props} />}
        <Maitaining {...this.props} />
        <Features {...this.props} />
        {canCrossShop(car.shop) && <PrepareRecord {...this.props} />}
        {canCrossShop(car.shop) && <Licenses {...this.props} />}
        {canCrossShop(car.shop) && <History {...this.props} />}
      </div>
    )
  }
}
