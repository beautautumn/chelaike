import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { create } from 'redux/modules/intentionPushHistories'
import { fetchOne as fetchIntention } from 'redux/modules/intentions'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionPush' })
@connect(
  (state, { id }) => ({
    intention: state.entities.intentions[id],
    saved: state.intentionPushHistories.saved,
    carsById: state.entities.cars
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      fetchIntention,
      showNotification,
    }, dispatch)
  })
)
export default class PushModal extends PureComponent {
  static propTypes = {
    intention: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    create: PropTypes.func.isRequired,
    fetchIntention: PropTypes.func.isRequired,
    carsById: PropTypes.object
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
    this.refs.form.submit()
  }

  handleSubmit = data => {
    const { create, intention, fetchIntention } = this.props
    create(intention.id, data).then(() => {
      fetchIntention(intention.id)
    })
  }

  render() {
    const { intention, show, carsById, handleHide } = this.props
    const intentionPushHistory = {
      checked: false,
      carIds: [],
      intentionType: intention.intentionType
    }

    return (
      <Modal
        title="跟进意向"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={intentionPushHistory}
          onSubmit={this.handleSubmit}
          intention={intention}
          carsById={carsById}
        />
      </Modal>
    )
  }
}
