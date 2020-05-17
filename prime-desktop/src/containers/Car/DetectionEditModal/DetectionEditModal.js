import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { fetch as fetchDetection, create, update } from 'redux/modules/carDetections'
import { fetch as fetchOss, shouldFetch } from 'redux/modules/oss'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './DetectionEditForm'

function fetchData({ store: { getState, dispatch }, props: { id } }) {
  if (shouldFetch(getState().oss)) {
    dispatch(fetchOss())
  }
  return dispatch(fetchDetection(id))
}

@connectModal({ name: 'carDetectionEdit', resolve: fetchData })
@connect(
  (state, { id }) => ({
    oss: state.oss,
    car: state.entities.cars[id],
    saved: state.carDetections.saved,
    saving: state.carDetections.saving,
    detection: state.carDetections.currentDetection,
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
    }, dispatch)
  })
)
export default class DetectionEditModal extends Component {
  static propTypes = {
    oss: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool,
    detection: PropTypes.object,
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.handleHide()
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { car, detection, create, update } = this.props
    if (detection && detection.id) {
      update(car.id, data)
    } else {
      create(car.id, data)
    }
  }

  render() {
    const { oss, car, show, handleHide, detection } = this.props

    return (
      <Modal
        title="检测报告"
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          oss={oss}
          initialValues={detection}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
