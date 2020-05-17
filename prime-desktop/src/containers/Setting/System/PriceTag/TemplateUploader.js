import { Component, PropTypes } from 'react'
import ReactDOM from 'react-dom'
import swf from 'WebUploader/dist/Uploader.swf'
import config from 'config'
import WebUploader from 'WebUploader/dist/webuploader'

export default class TemplateUploader extends Component {
  static propTypes = {
    children: PropTypes.object.isRequired,
    user: PropTypes.object.isRequired,
    handleUploadSuccess: PropTypes.func.isRequired,
    handleUploadError: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const $button = $(ReactDOM.findDOMNode(this)) // eslint-disable-line no-undef
    const uploader = WebUploader.create({ // eslint-disable-line no-undef
      swf,
      server: `${config.serverUrl}${config.basePath}/price_tag_templates`,
      pick: {
        id: $button,
        multiple: false
      },
      accept: {
        extensions: 'zip',
        mimeTypes: 'application/zip,application/octet-stream'
      },
      auto: true
    })

    uploader.on('uploadBeforeSend', (object, data, headers) => (
      headers['AutobotsToken'] = this.props.user.token // eslint-disable-line dot-notation
    ))

    uploader.on('uploadSuccess', () => {
      this.props.handleUploadSuccess()
    })


    uploader.on('uploadError', () => {
      this.props.handleUploadError()
    })
  }

  render() {
    return this.props.children
  }
}
