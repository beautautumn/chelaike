import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { Popconfirm, Alert } from 'antd'
import styles from './Form.scss'
import { Element } from 'react-scroll'
import PublisherListForCar from '../Inputs/PublisherListForCar'
import { show as showModal } from 'redux-modal'
import { fetchContacts, fetchStatus } from 'redux/modules/carPublish/platforms'
import { push } from 'react-router-redux'
import { fetch as fetchPlatformProfile } from 'redux/modules/carPublish/profiles'

function mapStateToProps(state) {
  return {
    syncStates: state.carPublish.platforms.syncStates,
    profile: state.carPublish.profiles.platformProfile,
    spinning: state.carPublish.platforms.spinning,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    ...bindActionCreators({
      showModal,
      fetchContacts,
      fetchStatus,
      fetchPlatformProfile,
      push,
    }, dispatch, 'inStock')
  }
}

const fields = [
  'publishers.che168.syncable', 'publishers.che168.sellerId'
]

@connect(mapStateToProps, mapDispatchToProps)
class Publisher extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    dirty: PropTypes.bool.isRequired,
    showModal: PropTypes.func.isRequired,
    push: PropTypes.func.isRequired,
    spinning: PropTypes.bool.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = { visible: false, syncStates: [] }
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.id && nextProps.id) {
      this.props.fetchStatus({ carId: nextProps.id })
    }
    if (!nextProps.profile) {
      this.props.fetchPlatformProfile()
    }
    if (this.props.syncStates !== nextProps.syncStates) {
      const { syncStates } = nextProps
      this.setState({ ...this.state, syncStates })
    }
  }

  onContactorChange = (platform) => (contactor) => {
    const syncStates = this.state.syncStates.map((state) => {
      if (state.platform === platform) {
        return { ...state, contactor }
      }
      return state
    })

    this.setState({ ...this.state, syncStates })
  }

  handleVisibleChange = (visible) => {
    if (!visible) {
      this.setState({ visible })
      return
    }
    if (!this.props.dirty) {
      this.confirm()
    } else {
      this.setState({ visible })
    }
  }

  confirm = () => {
    this.props.push('/setting/publishers_profile')
  }

  cancel() {
    this.setState({ visible: false })
  }

  renderWarningNavigator = () => (
    <Popconfirm
      title="车辆数据还未保存，是否继续？"
      visible={this.state.visible}
      onVisibleChange={this.handleVisibleChange}
      onConfirm={this.confirm}
      onCancel={this.cancel}
    >
      <a>前往绑定</a>
    </Popconfirm>
  )

  render() {
    const { showModal, profile, id, spinning } = this.props
    const { syncStates } = this.state
    const noSuccessBinding = syncStates.length === 0
    return (
      <Element name="publisher" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>一键发车</div>
        {noSuccessBinding && !id &&
          <Alert
            message="车辆入库后，才允许一键发车。"
            type="warning"
            showIcon
          />
        }
        {noSuccessBinding && id &&
          <Alert
            message="您还没有已绑定的发车账号，请先在“系统设置－业务设置－绑定账号”中进行账号绑定。"
            description={this.renderWarningNavigator()}
            type="warning"
            showIcon
          />
        }
        {!noSuccessBinding &&
          <PublisherListForCar
            id={id}
            profile={profile}
            syncStates={syncStates}
            showModal={showModal}
            onContactorChange={this.onContactorChange}
            spinning={spinning}
          />
        }
      </Element>
    )
  }
}

Publisher.fields = fields

export default Publisher
