import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { batchAssignAcquirer } from 'redux/modules/cars'
import Form from './Form'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'

@connectModal({ name: 'batchAssignAcquirer' })
@connect(
  (state) => ({
    selectedRowKeys: state.cars.inStock.selectedRowKeys,
    saved: state.cars.inStock.saved,
    saving: state.cars.inStock.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      batchAssignAcquirer,
    }, dispatch)
  })
)
export default class RefundModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    batchAssignAcquirer: PropTypes.func.isRequired,
    selectedRowKeys: PropTypes.array.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.handleHide()
    }
  }

  handleOk = () => {
    if (!this.props.saving) {
      this.refs.form.submit()
    }
  }

  handleSubmit = (data) => {
    const { selectedRowKeys } = this.props
    this.props.batchAssignAcquirer({
      carIds: selectedRowKeys,
      acquirer_id: data.acquirer
    })
  }

  render() {
    const { show, handleHide } = this.props

    return (
      <Modal
        title="批量修改车源负责人"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
