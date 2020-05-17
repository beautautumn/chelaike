import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetchMissingFields, publish } from 'redux/modules/carPublish/platforms'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import MissingFieldsForm from './MissingFieldsForm'

function fetchData({ store: { dispatch }, props: { id, platforms } }) {
  return dispatch(fetchMissingFields({ carId: id, platforms }))
}

@connectModal({ name: 'missingFields', resolve: fetchData })
@connect(
  (state) => ({
    missingFields: state.carPublish.platforms.missingFields,
  })
)
export default class MissingFieldsModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    missingFields: PropTypes.object.isRequired,
    id: PropTypes.number.isRequired,
    platforms: PropTypes.array.isRequired,
    relations: PropTypes.array.isRequired,
  }

  handleOk = () => {
    this.refs.form.submit()
  }

  handleSubmit = (values, dispatch) => {
    const { id, relations } = this.props
    return new Promise((resolve, reject) => {
      dispatch(publish({ carId: id, relations, extraAttrs: values }))
      .then(response => {
        if (response.type.includes('ERROR')) {
          reject({ _error: '发车失败' })
        } else {
          resolve()
          this.props.handleHide()
        }
      })
    })
  }

  render() {
    const { show, handleHide, missingFields } = this.props

    const initialValues = {}
    const fields = Object.keys(missingFields).reduce((pre, curr) => {
      initialValues[curr] = {}

      if (Array.isArray(missingFields[curr])) {
        for (const field of missingFields[curr]) {
          pre.push(curr + '.' + field.fieldName)
          if (field.default) {
            initialValues[curr][field.fieldName] = field.default
          }
        }
      }
      return pre
    }, [])

    return (
      <Modal
        title="以下信息未匹配或缺失，请补充"
        width={650}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <MissingFieldsForm
          ref="form"
          missingFields={missingFields}
          fields={fields}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
