import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { update } from 'redux/modules/transfers'
import { fetchOne as fetchCar } from 'redux/modules/cars'
import { fetch as fetchProvinces } from 'redux/modules/provinces'
import { fetch as fetchCities } from 'redux/modules/cities'
import { fetch as fetchOss, shouldFetch as shouldFetchOss } from 'redux/modules/oss'
import { connectModal } from 'redux-modal'
import AcquisitionForm from './AcquisitionForm/AcquisitionForm'
import SalesForm from './SalesForm/SalesForm'
import ImagesForm from './ImagesForm'
import { Tabs, Modal } from 'antd'
import confirmIfTooBig from 'helpers/confirmIfTooBig'

const { TabPane } = Tabs

const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 18 },
}

@connectModal({ name: 'licenseEdit' })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    transfersById: state.entities.transfers,
    enumValues: state.enumValues,
    provinces: state.provinces.data,
    cities: state.cities.data,
    saved: state.transfers.saved,
    saving: state.transfers.saving,
    oss: state.oss,
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      fetchCar,
      fetchCities,
      fetchProvinces,
      showNotification,
      fetchOss,
    }, dispatch)
  })
)
export default class EditModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    oss: PropTypes.object,
    transfersById: PropTypes.object.isRequired,
    fetchCar: PropTypes.func.isRequired,
    fetchCities: PropTypes.func.isRequired,
    fetchProvinces: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    fetchOss: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
  }

  constructor(props) {
    super(props)

    this.transferType = 'acquisition'
  }

  componentDidMount() {
    this.props.fetchProvinces()
    if (shouldFetchOss(this.props.oss)) {
      this.props.fetchOss()
    }
  }

  componentWillReceiveProps(nextprops) {
    if (!this.props.saved && nextprops.saved) {
      this.props.handleHide()

      // 为了更新销售过户信息中的现车牌号
      this.props.fetchCar(this.props.car.id)

      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleSwitchType = (type) => {
    this.transferType = type
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs[this.transferType].submit()
    }
  }

  handleSubmit = (data) => {
    confirmIfTooBig(data, [
      { key: 'transferFeeYuan', name: '过户费用', unit: '元' },
    ], () => {
      const { car } = this.props
      let finalType
      if (this.transferType === 'image') {
        finalType = 'acquisition'
      } else {
        finalType = this.transferType
      }
      this.props.update(car.id, finalType, data)
    })
  }

  render() {
    const { car, transfersById, oss, show, handleHide } = this.props

    const acquisitionTransfer = transfersById[car.acquisitionTransfer]
    acquisitionTransfer.imagesAttributes = acquisitionTransfer.images

    const saleTransfer = transfersById[car.saleTransfer]

    return (
      <Modal
        title="编辑牌证"
        width={950}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Tabs defaultactivekey="acquisition" onChange={this.handleSwitchType}>
          <TabPane tab="收购" key="acquisition">
            <AcquisitionForm
              ref="acquisition"
              car={car}
              initialValues={acquisitionTransfer}
              onSubmit={this.handleSubmit}
              formItemLayout={formItemLayout}
              {...this.props}
            />
          </TabPane>
          <TabPane tab="销售" key="sale">
            <SalesForm
              ref="sale"
              car={car}
              initialValues={saleTransfer}
              onSubmit={this.handleSubmit}
              formItemLayout={formItemLayout}
              {...this.props}
            />
          </TabPane>
          <TabPane tab="牌证图片" key="image">
            <ImagesForm
              ref="image"
              initialValues={acquisitionTransfer}
              onSubmit={this.handleSubmit}
              oss={oss}
            />
          </TabPane>
        </Tabs>
      </Modal>
    )
  }
}
