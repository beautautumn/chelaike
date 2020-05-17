import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import { Modal } from 'antd'
import { connectModal } from 'redux-modal'
import { syncFeatures } from 'models/form/car'
import { autoId } from 'decorators'
import cx from 'classnames'
import { CheckboxGroup } from 'components'
import styles from './style.scss'

@connectModal({ name: 'FeatureChoose' })
@connect(
  state => ({
    configurationNote: state.form.car.car.configurationNote,
  }),
  dispatch => bindActionCreators({ syncFeatures }, dispatch)
)
@autoId
export default class FeaturesChooseModal extends Component {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    handleHide: PropTypes.func.isRequired,
    features: PropTypes.array.isRequired,
    syncFeatures: PropTypes.func.isRequired,
    configurationNote: PropTypes.object,
    autoId: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    const { configurationNote } = props
    const selectedFeatures = configurationNote && configurationNote.value ?
      configurationNote.value.split('，') : []
    this.state = { features: selectedFeatures }
  }

  handleOk = () => {
    this.props.syncFeatures(this.state.features.join('，'))
    this.props.handleHide()
  }

  handleItemCheck = (features) => {
    this.setState({ features })
  }

  handleToggleAll = (event) => {
    const selectedAll = event.currentTarget.checked
    if (selectedAll) {
      const { features } = this.props
      this.setState({ features })
    } else {
      this.setState({ features: [] })
    }
  }

  render() {
    const { autoId, features, show, handleHide } = this.props
    const checkAll = features.every(elem => this.state.features.includes(elem))

    return (
      <Modal
        title="配置项选择"
        width={950}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={this.handleOk}
      >
        <div className="content">
          <div className="ui toggle checkbox">
            <input
              type="checkbox"
              id="toggleAll"
              checked={checkAll}
              onChange={this.handleToggleAll}
            />
            <label htmlFor="toggleAll">全选</label>
          </div>
          <CheckboxGroup value={this.state.features} onChange={this.handleItemCheck} >
            {Checkbox => (
              <div className="content">
                {features.map((feature, index) => (
                  <div key={index} className={cx('ui inline checkbox', styles.checkbox)}>
                    <Checkbox id={autoId()} value={feature} />
                    <label htmlFor={autoId()}>{feature}</label>
                  </div>
                ))}
              </div>
            )}
          </CheckboxGroup>
        </div>
      </Modal>
    )
  }
}
