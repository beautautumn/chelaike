import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { connectModal } from 'redux-modal'
import Oss, { shouldFetch } from 'models/oss'
import carFactory from 'models/car'
import { Modal } from 'antd'
import Form from './Form'

const Car = carFactory('car::inStock')


@connectModal({ name: 'carImageUpload' })
@connect(
  (_state, { id }) => ({
    oss: Oss.getState(),
    car: Car.select('one', id),
  })
)
export default class ImageUploadModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    id: PropTypes.number.isRequired,
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    oss: PropTypes.object,
    handleHide: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { dispatch, oss } = this.props
    if (shouldFetch(oss)) {
      dispatch(Oss.fetch())
    }
  }

  handleOk = () => {
    this.refs.form.submit()
  }

  handleSubmit = data => {
    const { dispatch, id } = this.props
    dispatch(Car.updateImage(id, data))
  }

  render() {
    const { show, handleHide, car, oss } = this.props

    const initialValues = {
      car: {
        allianceImagesAttributes: car.allianceImages,
      },
    }

    return (
      <Modal
        title="车辆联盟图片上传"
        width={960}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
          oss={oss}
        />
      </Modal>
    )
  }
}
