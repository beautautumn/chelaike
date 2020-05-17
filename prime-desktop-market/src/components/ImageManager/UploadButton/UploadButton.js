import React, { Component, PropTypes } from 'react'
import { Icon } from 'antd'
import ImageUploader from '../../UploadButton/ImageUploader'
import styles from './UploadButton.scss'

export default class UploadButton extends Component {
  static propTypes = {
    oss: PropTypes.object,
    fileList: PropTypes.array,
    handleChange: PropTypes.func.isRequired
  }

  render() {
    const { oss, handleChange } = this.props

    return (
      <ImageUploader
        oss={oss}
        onChange={handleChange}
      >
        <div className={styles.uploadButton}>
          <div>
            <Icon type="plus" />
            <div className={styles.text}>上传图片</div>
          </div>
        </div>
      </ImageUploader>
    )
  }
}
