import React, { Component, PropTypes } from 'react'
import cx from 'classnames'
import ImageUploader from 'components/UploadButton/ImageUploader'
import styles from '../LogoUploader/LogoUploader.scss'
import { scale } from 'helpers/image'
import last from 'lodash/last'

export default class LogoUploader extends Component {
  static propTypes = {
    oss: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    value: PropTypes.string,
  }

  handleChange = (images) => {
    if (images) {
      this.props.onChange(last(images).url)
    }
  }

  render() {
    const { oss, value } = this.props

    let logo

    if (value) {
      logo = (
        <img
          role="presentation"
          className={cx('ui image', styles.image)}
          src={scale(value, '250x150')}
        />
      )
    }

    return (
      <div className="field">
        <label>公司 Logo（建议图片宽高比例为1:1）</label>
        {logo}
        <br />
        <ImageUploader oss={oss} onChange={this.handleChange}>
          <div
            className={cx('mini ui primary button fileinputButton', styles.logoButton)}
            title="点击或拖拽上传图片"
          >
            上传 Logo
          </div>
        </ImageUploader>
      </div>
    )
  }
}
