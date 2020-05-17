import React, { PropTypes } from 'react'
import { Icon } from 'antd'
import { ImageUploader } from 'components'
import styles from './style.scss'

export default function UploadButton({ oss, handleChange }) {
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

UploadButton.propTypes = {
  oss: PropTypes.object,
  fileList: PropTypes.array,
  handleChange: PropTypes.func.isRequired,
}
