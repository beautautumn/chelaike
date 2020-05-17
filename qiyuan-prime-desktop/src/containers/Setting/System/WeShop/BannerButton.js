import React, { Component, PropTypes } from 'react'
import { OssUploadButton } from 'components'
import styles from './WeShop.scss'

export default class BannerButton extends Component {
  static propTypes = {
    oss: PropTypes.object,
    defaultValue: PropTypes.array,
    value: PropTypes.array,
    onChange: PropTypes.func.isRequired
  }

  handleUpload = url => {
    const { defaultValue, value, onChange } = this.props
    const urls = value || defaultValue
    onChange([...urls, url])
  }

  remove = index => () => {
    const { defaultValue, value, onChange } = this.props
    const urls = value || defaultValue
    const nextUrls = urls.splice(index + 1, 1)
    onChange(nextUrls)
  }

  render() {
    const { oss, defaultValue, value } = this.props
    const urls = value || defaultValue

    return (
      <div>
        {urls.map((url, index) => (
          <div key={index}>
            <div className="image">
              <img className="ui small image" role="presentation" src={url} />
            </div>
            <div className={styles.removeButton} onClick={this.remove(index)}>
              删除
            </div>
          </div>
        ))}
        <br />
        <OssUploadButton text="上传图片" oss={oss} onUpload={this.handleUpload} />
      </div>
    )
  }
}
