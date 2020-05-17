import React, { Component, PropTypes } from 'react'
import cx from 'classnames'
import ImageUploader from 'components/UploadButton/ImageUploader'
import styles from './FacadeUploader.scss'
import { scale } from 'helpers/image'
import last from 'lodash/last'

export default class FacadeUploader extends Component {
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

    let facade

    if (value) {
      facade = (
        <img
          role="presentation"
          className={cx('ui image', styles.image)}
          src={scale(value, '780x364')}
        />
      )
    }

    return (
      <div className="field">
        <label>公司门头照片，建议比例（15:7）</label>
        {facade}
        <br />
        <ImageUploader oss={oss} onChange={this.handleChange}>
          <div
            className={cx('mini ui primary button fileinputButton', styles.facadeButton)}
            title="点击或拖拽上传图片"
          >
            上传 Logo
          </div>
        </ImageUploader>
      </div>
    )
  }
}
