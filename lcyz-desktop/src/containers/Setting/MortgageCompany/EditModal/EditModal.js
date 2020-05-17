import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { update, create } from 'redux/modules/mortgageCompanies'
import { show as showNotification } from 'redux/modules/notification'
import { entitySelector } from 'redux/selectors/entities'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'mortgageCompanyEdit' })
@connect(
  (state, { id }) => ({
    mortgageCompany: entitySelector('mortgageCompanies')(state, id),
    saved: state.mortgageCompanies.saved,
    saving: state.mortgageCompanies.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      create,
      showNotification,
    }, dispatch)
  })
)
export default class EditModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    mortgageCompany: PropTypes.object,
    update: PropTypes.func.isRequired,
    create: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
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
    const { mortgageCompany } = this.props
    if (mortgageCompany && mortgageCompany.id) {
      this.props.update(data)
    } else {
      this.props.create(data)
    }
  }

  render() {
    const { mortgageCompany, show, handleHide } = this.props
    const title = mortgageCompany ? '编辑按揭公司' : '新增按揭公司'

    return (
      <Modal
        title={title}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={mortgageCompany}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
