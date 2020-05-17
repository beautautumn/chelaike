import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { show as showNotification } from 'redux/modules/notification'
import { update } from 'redux/modules/intentionShares'
import { fetchOne as fetchIntention } from 'redux/modules/intentions'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionShare' })
@connect(
  (state, { id }) => ({
    intention: state.entities.intentions[id],
    saved: state.intentionShares.saved,
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      fetchIntention,
      showNotification,
    }, dispatch)
  })
)
export default class ShareModal extends PureComponent {
  static propTypes = {
    intention: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    fetchIntention: PropTypes.func.isRequired,
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
    const { update, intention, fetchIntention } = this.props
    update({ id: intention.id, ...data }).then(() => {
      fetchIntention(intention.id)
    })
  }

  render() {
    const { intention, show, handleHide } = this.props
    const { sharedUsers } = intention

    return (
      <Modal
        title="意向分享"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={{ sharedUsers }}
          onSubmit={this.handleSubmit}
          intention={intention}
        />
      </Modal>
    )
  }
}
