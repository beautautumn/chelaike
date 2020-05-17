import React, { Component, PropTypes } from 'react'
import { OssUploadButton } from 'components'

export default class QrcodeButton extends Component {
  static propTypes = {
    oss: PropTypes.object,
    defaultValue: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func.isRequired
  }

  render() {
    const { oss, defaultValue, value, onChange } = this.props
    const url = value || defaultValue

    return (
      <div>
        {url && <img className="ui small image" role="presentation" src={url} />}
        <br />
        <OssUploadButton text="上传二维码图片" oss={oss} onUpload={onChange} />
      </div>
    )
  }
}
