import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/intentionPushHistories'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import Item from './Item'

@connectModal({ name: 'pushHistory' })
@connect(
  (state, { intentionId }) => ({
    intentionPushHistories: visibleEntitiesSelector('intentionPushHistories')(state),
    intention: state.entities.intentions[intentionId],
    usersById: state.entities.users
  }),
  dispatch => ({
    ...bindActionCreators({ fetch }, dispatch)
  })
)
export default class PushHistoryModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    intentionPushHistories: PropTypes.array.isRequired,
    intention: PropTypes.object.isRequired,
    usersById: PropTypes.object,
    fetch: PropTypes.func.isRequired,
    handleHide: PropTypes.func.isRequired
  }

  componentDidMount() {
    this.props.fetch(this.props.intention.id)
  }

  renderItems() {
    const { intentionPushHistories, usersById } = this.props

    return intentionPushHistories.map((intentionPushHistory) => (
      <Item
        key={intentionPushHistory.id}
        intentionPushHistory={intentionPushHistory}
        usersById={usersById}
      />
    ))
  }

  render() {
    const { intention, show, handleHide } = this.props

    return (
      <Modal
        title={`${intention.customerName}的跟进历史`}
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={handleHide}
      >
        <div>
          {this.renderItems()}
        </div>
      </Modal>
    )
  }
}
