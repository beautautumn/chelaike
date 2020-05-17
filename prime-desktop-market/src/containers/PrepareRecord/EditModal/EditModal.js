import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { update, fetch as fetchPrepareRecords } from 'redux/modules/prepareRecords'
import { Modal } from 'antd'
import Form from './Form'
import { connectModal } from 'redux-modal'

function fetchData({ store: { dispatch }, props: { id } }) {
  return dispatch(fetchPrepareRecords(id))
}

@connectModal({ name: 'prepareRecordEdit', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    prepareRecord: state.prepareRecords.currentPrepareRecord,
    saved: state.prepareRecords.saved,
    saving: state.prepareRecords.saving,
    enumValues: state.enumValues
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      showNotification,
    }, dispatch)
  })
)
export default class EditModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    prepareRecord: PropTypes.object.isRequired,
    update: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    enumValues: PropTypes.object.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
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
    const { car } = this.props
    this.props.update(car.id, data)
  }

  render() {
    const { car, prepareRecord, enumValues, show, handleHide } = this.props

    prepareRecord.prepareItemsAttributes = prepareRecord.prepareItems
    if (prepareRecord.preparer) {
      prepareRecord.preparerId = prepareRecord.preparer.id
    }

    return (
      <Modal
        title="整备编辑"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          initialValues={prepareRecord}
          onSubmit={this.handleSubmit}
          enumValues={enumValues}
        />
      </Modal>
    )
  }
}
