import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchContacts, fetchStatus, deletePublish } from 'redux/modules/carPublish/platforms'
import { Modal, Button } from 'antd'
import { connectModal, show as showModal } from 'redux-modal'
import PublisherList from './PublisherList'
import { push } from 'react-router-redux'

function fetchData({ store: { dispatch }, props: { id } }) {
  return dispatch(fetchStatus({ carId: id }))
}

@connectModal({ name: 'syncPublish', resolve: fetchData })
@connect(
  (state, { id }) => ({
    car: state.entities.cars[id],
    contacts: state.carPublish.platforms.contacts,
    syncStates: state.carPublish.platforms.syncStates,
    spinning: state.carPublish.platforms.spinning,
  }),
  dispatch => ({
    ...bindActionCreators({
      showModal,
      push,
      deletePublish,
      fetchContacts
    }, dispatch)
  })
)
export default class PublisherModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    car: PropTypes.object.isRequired,
    contacts: PropTypes.object,
    syncStates: PropTypes.array.isRequired,
    showModal: PropTypes.func.isRequired,
    push: PropTypes.func.isRequired,
    deletePublish: PropTypes.func.isRequired,
    spinning: PropTypes.bool.isRequired,
  }

  constructor(props) {
    super(props)

    const initState = {
      syncStates: props.syncStates
    }
    this.state = initState
  }

  componentWillMount() {
    this.props.fetchContacts()
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.syncStates !== nextProps.syncStates) {
      const { syncStates } = nextProps
      this.setState({ syncStates })
    }
  }

  onContactorChange = (platform) => (contactor) => {
    const syncStates = this.state.syncStates.map((state) => {
      if (state.platform === platform) {
        return { ...state, contactor }
      }
      return state
    })

    this.setState({ syncStates })
  }

  render() {
    const {
      show,
      handleHide,
      car,
      contacts,
      showModal,
      push,
      deletePublish,
      spinning
    } = this.props
    const { syncStates } = this.state

    return (
      <Modal
        title="一键发车"
        width={850}
        maskClosable={false}
        visible={show}
        footer={[
          <Button key="back" type="ghost" size="large" onClick={handleHide}>关闭</Button>
        ]}
        onCancel={handleHide}
      >
        <PublisherList
          inModal
          car={car}
          contacts={contacts}
          syncStates={syncStates}
          showModal={showModal}
          onContactorChange={this.onContactorChange}
          push={push}
          deletePublish={deletePublish}
          spinning={spinning}
        />
      </Modal>
    )
  }
}
