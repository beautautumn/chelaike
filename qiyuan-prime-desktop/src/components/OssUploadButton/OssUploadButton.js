import React, { Component, PropTypes } from 'react'
import superagent from 'superagent'
import uuid from 'uuid'
import cx from 'classnames'
import styles from './OssUploadButton.scss'
import config from 'config'

export default class OssUploadButton extends Component {
  static propTypes = {
    text: PropTypes.string,
    oss: PropTypes.object.isRequired,
    onUpload: PropTypes.func.isRequired
  }

  handleChange = event => {
    const { oss } = this.props
    const file = event.currentTarget.files[0]
    if (!file) { return }
    const ext = file.type.split('/')[1]
    const filename = `images/${uuid.v4()}.${ext}`
    const formData = new FormData
    formData.append('OSSAccessKeyId', oss.ossKey)
    formData.append('policy', oss.policy)
    formData.append('signature', oss.signature)
    formData.append('success_action_status', 201)
    formData.append('key', filename)
    formData.append('file', file)
    superagent
      .post(config.ossUrl)
      .accept('xml')
      .send(formData)
      .end((err, res) => {
        const url = res.xhr.responseXML.getElementsByTagName('Location')[0].innerHTML
        this.props.onUpload(url)
      })
  }

  render() {
    const { text } = this.props

    return (
      <div className={cx('ui blue button', styles.button)}>
        {text}
        <input type="file" className={styles.input} onChange={this.handleChange} />
      </div>
    )
  }
}
