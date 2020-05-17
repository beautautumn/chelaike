import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { Row, Col, Button, Alert } from 'antd'
import { formOptimize } from 'decorators'
import styles from './Form.scss'
import { show as showModal } from 'redux-modal'
import Textarea from 'react-textarea-autosize'
import FeatureChooseModal from '../Inputs/Features/FeatureChooseModal'
import FeaturesInput from '../Inputs/Features/FeaturesInput'
import { Element } from 'react-scroll'

function mapStateToProps(state) {
  return {
    currentUser: state.auth.user,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    ...bindActionCreators({
      showModal
    }, dispatch, 'inStock')
  }
}

const fields = [
  'car.id', 'car.manufacturerConfiguration', 'car.configurationNote'
]

@connect(mapStateToProps, mapDispatchToProps)
@formOptimize(fields)
class Features extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    showModal: PropTypes.func.isRequired,
  }

  handleSyncFeatures = (field) => () => {
    const note = []
    const features = field.value || field.defaultValue
    if (!features) return
    features.forEach((group) => {
      if (!['基本参数', '车身', '发动机', '变速箱'].includes(group.name)) {
        group.fields.forEach((field) => {
          if (field.present) {
            note.push(field.name)
          }
        })
      }
    })
    this.props.showModal('FeatureChoose', { features: note })
  }

  render() {
    const { manufacturerConfiguration, configurationNote } = this.props.fields.car

    return (
      <Element name="features" className={styles.formPanel + ' ' + styles.additionalBottoMargin}>
        <div className={styles.formPanelTitle}>车辆配置</div>
        <Row>
          <FeaturesInput {...manufacturerConfiguration} />
          <Row className={styles.featuresButton}>
            <Col span="3">
              <Button
                type="primary"
                size="large"
                onClick={this.handleSyncFeatures(manufacturerConfiguration)}
              >同步配置</Button>
            </Col>
            <Col span="10">
              <Alert message="如果价签中有配置项，则价签将显示以下配置信息" type="success" showIcon />
            </Col>
          </Row>
          <Row className={styles.group}><Col>亮点配置</Col></Row>
          <Row>
            <Col span="24">
              <Textarea rows={4} className="ant-input ant-input-lg" {...configurationNote} />
            </Col>
          </Row>
          <FeatureChooseModal />
        </Row>
      </Element>
    )
  }
}

Features.fields = fields

export default Features
