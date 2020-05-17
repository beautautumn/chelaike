import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { update } from 'redux/modules/carPublish/profiles'
import { show as showNotification } from 'redux/modules/notification'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'profileEdit' })
@connect(
  (state) => ({
    platformProfile: state.carPublish.profiles.platformProfile,
    saved: state.carPublish.profiles.saved,
    saving: state.carPublish.profiles.saving,
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
    platformProfile: PropTypes.object,
    update: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saved: PropTypes.bool,
    saving: PropTypes.bool
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

  handleSubmit = (data) => (
    new Promise((resolve, reject) => {
      this.props.update(data)
      .then(response => {
        if (response.type.includes('FAILURE')) {
          let errorInfo = '绑定账号失败，请检查用户名和密码。'
          if (response.error.errors) errorInfo = response.error.errors
          reject({ _error: errorInfo })
        } else {
          resolve()
        }
      })
    })
  )

  render() {
    const { platformProfile, show, handleHide, site, siteName, saving } = this.props

    const initialValues = {
      platform: site,
      data: platformProfile ? platformProfile[site] : {}
    }

    return (
      <Modal
        title={"绑定账号"}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
        confirmLoading={saving}
      >
        <Form
          ref="form"
          initialValues={initialValues}
          handleCancel={handleHide}
          onSubmit={this.handleSubmit}
          siteName={siteName}
        />
      </Modal>
    )
  }
}
