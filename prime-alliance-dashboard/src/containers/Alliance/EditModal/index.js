import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Company from 'models/company'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'companyEdit' })
@connect(
  (_state, { id }) => ({
    company: Company.select('one', id),
  })
)
export default class EditModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    company: PropTypes.object,
    handleHide: PropTypes.func.isRequired,
  }

  handleOk = () => {
    this.refs.form.submit()
  }

  handleSubmit = (data) => {
    this.props.dispatch(Company.update(data))
  }

  render() {
    const { company, show, handleHide } = this.props

    return (
      <Modal
        title={company.name}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={company}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
