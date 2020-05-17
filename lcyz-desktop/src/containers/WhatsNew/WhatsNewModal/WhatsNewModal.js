import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { Modal, Button } from 'antd'
import styles from './WhatsNewModal.scss'
import log from './ChangeLog/latest.md'
import { VERSION } from 'constants'

function versionToNumber(version) {
  if (!version) return 0
  return +version.replace(/\./g, '')
}

@connect(
  state => ({
    currentUser: state.auth.user
  })
)
export default class WhatsNew extends Component {
  static propTypes = {
    currentUser: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props)

    this.key = `prime-desktop.${props.currentUser.username}.whatsnew`

    this.state = { show: false }
  }

  setShowed() {
    localStorage.setItem(this.key, VERSION)
  }

  haveShowed() {
    const prev = versionToNumber(localStorage.getItem(this.key))
    const current = versionToNumber(VERSION)
    return current <= prev
  }

  handleClose = () => {
    this.setState({ show: false }, this.setShowed)
  }

  render() {
    const Footer = (
      <Button type="ghost" size="large" onClick={this.handleClose}>
        关闭
      </Button>
    )

    return (
      <Modal
        title="车来客更新啦"
        visible={this.state.show}
        footer={Footer}
      >
        <div className={styles.log} dangerouslySetInnerHTML={{ __html: log }} />
      </Modal>
    )
  }
}
