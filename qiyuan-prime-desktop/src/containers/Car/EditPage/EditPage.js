import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { connectData } from 'decorators'
import { create, update, fetchEdit } from 'redux/modules/cars'
import styles from './EditPage.scss'
import Navbar from './Navbar'
import { goBack } from 'react-router-redux'
import isBlank from 'utils/isBlank'
import { editDefaultValues } from 'redux/selectors/cars'
import EditForm from './EditForm'
import { show as showNotification } from 'redux/modules/notification'
import Helmet from 'react-helmet'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

function fetchData(getState, dispatch, location, params) {
  if (params.id) {
    return dispatch(fetchEdit(params.id))
  }
}

const useableTabsWhenCarIsOutStock = ['basic']

@connectData(fetchData)
@connect(
  (state, { params }) => {
    const props = {
      saved: state.cars.inStock.saved,
      saving: state.cars.inStock.saving,
      defaultValues: editDefaultValues(state, params.id)
    }
    return props
  },
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      goBack,
      showNotification,
    }, dispatch, 'inStock')
  })
)
export default class EditPage extends Component {
  static propTypes = {
    create: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    update: PropTypes.func.isRequired,
    params: PropTypes.object,
    goBack: PropTypes.func.isRequired,
    location: PropTypes.object.isRequired,
    defaultValues: PropTypes.object.isRequired,
    showNotification: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    const initState = {
      subformStatus: {},
      tab: null
    }
    this.state = initState
  }

  handleCancel = () => {
    this.props.goBack()
  }

  handleSubmit = (data) => {
    if (this.props.saving) return

    const checkFields = [
      { key: 'car.acquisitionPriceWan', name: '收购价格', unit: '万元' },
      { key: 'car.consignorPriceWan', name: '寄卖价', unit: '万元' },
      { key: 'car.showPriceWan', name: '展厅标价', unit: '万元' },
      { key: 'car.onlinePriceWan', name: '网络标价', unit: '万元' },
      { key: 'car.salesMinimunPriceWan', name: '销售底价', unit: '万元' },
      { key: 'car.managerPriceWan', name: '经理价', unit: '万元' },
      { key: 'car.allianceMinimunPriceWan', name: '联盟底价', unit: '万元' },
      { key: 'car.newCarGuidePriceWan', name: '新车指导价', unit: '万元' },
      { key: 'car.newCarAdditionalPriceWan', name: '新车加价', unit: '万元' },
      { key: 'car.newCarFinalPriceWan', name: '新车完税价', unit: '万元' },
      { key: 'car.mileage', name: '表显里程', unit: '万公里' },
      { key: 'car.mileageInFact', name: '实际里程', unit: '万公里' },
    ]

    return new Promise((resolve, reject) => {
      confirmIfTooBig(data, checkFields, () => {
        if (isBlank(data.car.allianceMinimunPriceWan)) {
          data.car.allianceMinimunPriceWan = data.car.managerPriceWan
        }
        data.car.licensedAt += '-01'
        data.car.manufacturedAt += '-01'
        data.acquisitionTransfer.compulsoryInsuranceEndAt += '-01'
        data.acquisitionTransfer.annualInspectionEndAt += '-01'
        data.acquisitionTransfer.commercialInsuranceEndAt += '-01'

        const { params, update, create } = this.props
        const promise = params.id ? update(data) : create(data)
        promise.then((response) => {
          if (response.error) {
            this.props.showNotification({ type: 'error', message: response.error.message })
            reject(response.error.errors)
          } else {
            this.props.showNotification({ type: 'success', message: '保存成功' })
            resolve()
          }
        })
      })
    })
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
      tab
    })
  }

  render() {
    const { defaultValues } = this.props
    const { subformStatus, tab } = this.state
    const isNewCar = !Boolean(defaultValues.car.id)
    const shopId = defaultValues.car.shopId
    const carIsOutStock = [
      'acquisition_refunded', 'driven_back', 'sold',
      'alliance_stocked_out', 'alliance_refunded'
    ].includes(defaultValues.car.state)

    return (
      <div className={styles.container}>
        <Helmet title={isNewCar ? '车辆入库' : defaultValues.car.name} />
        <Navbar
          tab={tab}
          subformStatus={subformStatus}
          isNewCar={isNewCar}
          carState={defaultValues.car.state}
          useableTabs={carIsOutStock ? useableTabsWhenCarIsOutStock : null}
          shopId={shopId}
        />
        <div className={styles.content}>
          <EditForm
            initialValues={defaultValues}
            onSubmit={this.handleSubmit}
            handleCancel={this.handleCancel}
            markSubformStatus={this.markSubformStatus}
            markActivedTab={this.markActivedTab}
            useableTabs={carIsOutStock ? useableTabsWhenCarIsOutStock : null}
            shopId={shopId}
          />
        </div>
      </div>
    )
  }
}
