import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetch as fetchUsers } from 'redux/modules/users'
import { assign } from 'redux/modules/intentions'
import { show as showNotification } from 'redux/modules/notification'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { connectModal } from 'redux-modal'
import { Modal } from 'antd'
import Form from './Form'

@connectModal({ name: 'intentionAssign' })
@connect(
  (state, { as }) => ({
    checkedIds: state.intentions[as].checkedIds,
    users: visibleEntitiesSelector('users')(state),
    saved: state.intentions[as].saved,
    saving: state.intentions[as].saving
  }),
  (dispatch, { as }) => ({
    ...bindActionCreators({
      fetchUsers,
      assign,
      showNotification,
    }, dispatch, as)
  })
)
export default class AssignModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    checkedIds: PropTypes.array.isRequired,
    fetchUsers: PropTypes.func.isRequired,
    assign: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool,
    users: PropTypes.array.isRequired,
    showNotification: PropTypes.func.isRequired,
    as: PropTypes.string.isRequired
  }

  componentDidMount() {
    this.props.fetchUsers({ intention: 1 })
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
    this.props.assign(this.props.as, {
      ...data,
      intentionIds: this.props.checkedIds,
    })
  }

  render() {
    const { checkedIds, show, handleHide } = this.props
    const users = this.props.users.map((user) => ({
      value: user.id,
      text: `${user.firstLetter} ${user.name}（${user.intentionsCount}）`
    }))

    return (
      <Modal
        title="分配意向"
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <Form
          ref="form"
          checkedIds={checkedIds}
          users={users}
          onSubmit={this.handleSubmit}
        />
      </Modal>
    )
  }
}
