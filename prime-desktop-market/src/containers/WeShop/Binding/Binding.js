import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { connectData } from 'decorators'
import { Segment } from 'components'
import { Row, Col, Alert, Modal, Button } from 'antd'
import styles from './Bingding.scss'
import { authorization as fetch } from 'redux/modules/weShop'

function fetchData(getState, dispatch) {
  return dispatch(fetch())
}

@connectData(fetchData)
@connect(
  state => ({
    authorization: state.weShop.authorization,
    enumValues: state.enumValues,
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
    }, dispatch)
  })
)
export default class Bingding extends Component {
  static propTypes = {
    authorization: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = {
      visible: false
    }
  }

  showModal = () => {
    this.setState({ visible: true })
  }

  handleOk = () => {
    this.props.fetch()
    this.setState({ visible: false })
  }

  handleCancel = () => {
    this.setState({ visible: false })
  }

  render() {
    const { authorization, enumValues } = this.props

    const serviceType = enumValues.wechat_app.service_type_info

    return (
      <div>
        <Segment className="ui segment">
          <h4>绑定公众号</h4>
          {!authorization.wechatApp &&
            <Row>
              <Col offset="3">
                <div className={styles.title}>绑定微信公众号，把车客来和微信打通</div>
                <div className={styles.content}>绑定后即可在这里管理您的公众号</div>
                <a
                  href={authorization.authorizationUrl}
                  target="_blank"
                  onClick={this.showModal}
                >
                  <div className={styles.bindingButton}></div>
                </a>
                <div className={styles.tips}>
                  <h5>温馨提示：</h5>
                  <p>只有认证的微信服务号才享受价签扫码关注公众号功能，订阅号不建议绑定</p>
                </div>
              </Col>
            </Row>
          }
          {authorization.wechatApp &&
            <Row className={styles.info}>
              <Alert
                message="您已经绑定公众号"
                description=" "
                type="success"
                showIcon
              />
              <Col span="4" className={styles.labels}>
                <div>公众微信号：</div>
                <div>公众号昵称：</div>
                <div>微信账号类型：</div>
                <div>是否认证：</div>
              </Col>
              <Col span="2" >
                <div>{' ' + authorization.wechatApp.userName}</div>
                <div>{' ' + authorization.wechatApp.nickName}</div>
                <div>{' ' + serviceType[authorization.wechatApp.serviceTypeInfo]}</div>
                <div>{' ' + authorization.wechatApp.verifyTypeInfo ? '是' : '否'}</div>
              </Col>
            </Row>
          }
        </Segment>

        <Modal
          visible={this.state.visible}
          title="提示"
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          footer={(
            <Row>
              <Col span="7" offset="5">
                <Button type="primary" size="large" onClick={this.handleOk}>已成功设置</Button>
              </Col>
              <Col span="5" offset="1">
                <a
                  className="ant-btn ant-btn-ghost ant-btn-lg"
                  href={authorization.authorizationUrl}
                  target="_blank"
                >
                  授权失败，重试
                </a>
              </Col>
            </Row>
          )}
        >
          <h5>请在新窗口中完成微信公众号的授权</h5>
        </Modal>
      </div>
    )
  }
}
