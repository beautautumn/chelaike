import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, update } from 'redux/modules/alliances'
import Form from './Form'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import { show as showNotification } from 'redux/modules/notification'

function fetchData({ store: { dispatch }, props: { id } }) {
  return dispatch(fetch(id))
}

@connectModal({ name: 'allianceSelect', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    allAlliances: state.alliances.allAlliances,
    alliances: state.alliances.allowedAlliances,
    saved: state.alliances.saved,
    saving: state.alliances.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      showNotification
    }, dispatch)
  })
)
export default class AllianceModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    car: PropTypes.object.isRequired,
    alliances: PropTypes.array.isRequired,
    allAlliances: PropTypes.array.isRequired,
    update: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool,
    showNotification: PropTypes.func.isRequired,
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
    this.props.update({ id: car.id, alliances: data.allianceIds })
  }

  render() {
    const { car, show, handleHide, allAlliances, alliances } = this.props

    const initialValues = {
      allianceIds: alliances.map(alliance => alliance.id)
    }

    const options = allAlliances.map(alliance => ({ label: alliance.name, value: alliance.id }))

    return (
      <Modal
        title="联盟展示"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          car={car}
          options={options}
          initialValues={initialValues}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
