import React, { Component, PropTypes } from 'react'
import ImageUploader from './ImageUploader'
import cx from 'classnames'
import styles from './UploadButton.scss'

export default class UploadButton extends Component {
  static propTypes = {
    oss: PropTypes.object,
    handleChange: PropTypes.func.isRequired
  }

  render() {
    const { oss, handleChange } = this.props
    return (
      <ImageUploader
        oss={oss}
        onChange={handleChange}
      >
        <span className={styles.uploadButton} title="点击或拖拽上传图片">
          <i className={cx('cloud upload icon', styles.icon)} />
        </span>
      </ImageUploader>
    )
  }
}
