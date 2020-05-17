import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Auth from 'models/auth'
import { Row, Col, Button, Alert, Input } from 'antd'
import { formOptimize } from 'decorators'
import { show as showModal } from 'redux-modal'
import ChooseModal from './ChooseModal'
import Inputs from './Inputs'
import { Element } from 'react-scroll'
import cx from 'classnames'
import styles from '../../style.scss'

function mapStateToProps(_state) {
  return {
    currentUser: Auth.getState().user,
  }
}

const fields = [
  'car.id', 'car.manufacturerConfiguration', 'car.configurationNote',
]

@connect(mapStateToProps)
@formOptimize(fields)
class Features extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    fields: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
  }

  handleSyncFeatures = (field) => () => {
    const { dispatch } = this.props
    const note = []
    const features = field.value || field.defaultValue
    if (!features) return
    features.forEach((group) => {
      if (!['基本参数', '车身', '发动机', '变速箱'].includes(group.name)) {
        group.fields.forEach((field) => {
          if (field.present && field.value !== '') {
            note.push(field.name)
          }
        })
      }
    })
    dispatch(showModal('FeatureChoose', { features: note }))
  }

  render() {
    const { manufacturerConfiguration, configurationNote } = this.props.fields.car

    return (
      <Element name="features" className={cx(styles.formPanel, styles.additionalBottoMargin)}>
        <div className={styles.formPanelTitle}>车辆配置</div>
        <Row>
          <Inputs {...manufacturerConfiguration} />
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
          <Row className={styles.group}><Col>配置说明</Col></Row>
          <Row>
            <Col span="24">
              <Input type="textarea" autosize rows={4} {...configurationNote} />
            </Col>
          </Row>
          <ChooseModal />
        </Row>
      </Element>
    )
  }
}

Features.fields = fields

export default Features
