import { Component, PropTypes } from 'react'
import ReactDOM from 'react-dom'
import uuid from 'uuid'
import swf from 'WebUploader/dist/Uploader.swf'
import WebUploader from 'WebUploader/dist/webuploader'
import config from 'config'

export default class ImageUploader extends Component {
  static propTypes = {
    children: PropTypes.element.isRequired,
    onChange: PropTypes.func.isRequired,
    oss: PropTypes.object.isRequired,
    multiple: PropTypes.bool,
    compress: PropTypes.bool,
  }

  constructor(props) {
    super(props)

    this.images = []
  }

  componentDidMount() {
    if (this.props.oss.fetched) {
      this.initializeUploader(this.props.oss)
    }
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.oss.fetch && nextProps.oss.fetched) {
      this.initializeUploader(nextProps.oss)
    }
  }

  componentWillUnmount() {
    if (this.uploader) {
      this.uploader.destroy()
    }
  }

  initializeUploader(oss) {
    if (this.initialized) {
      return
    }

    const { multiple, compress, onChange } = this.props

    const $button = $(ReactDOM.findDOMNode(this)) // eslint-disable-line no-undef

    this.uploader = WebUploader.create({ // eslint-disable-line no-undef
      swf,
      server: config.ossUrl,
      pick: {
        id: $button,
        multiple,
      },
      dnd: $button,
      accept: {
        extensions: 'gif,jpg,jpeg,bmp,png',
        mimeTypes: 'image/*',
      },
      prepareNextFile: true,
      resize: false,
      auto: true,
      formData: {
        OSSAccessKeyId: oss.ossKey,
        policy: oss.policy,
        Signature: oss.signature,
        success_action_status: 201,
      },
      compress: compress && {
        quality: 70,
        compressSize: 400,
      },
      duplicate: true,
    })

    this.uploader.on('fileQueued', (file) => {
      file.uploading = true
      file.uuid = uuid.v4()
      this.images.push(file)

      this.uploader.makeThumb(file, (error, src) => {
        file.preview = src
        onChange(this.images)
      }, 253, 150)
    })

    this.uploader.on('uploadBeforeSend', (object, data) => {
      data.key = `images/${object.file.uuid}.${object.file.ext}`
    })

    this.uploader.on('uploadSuccess', (file, response) => {
      /*eslint-disable*/
      file.url = `${config.staticUrl}/${$(response._raw).find('Key').text()}`
      /*eslint-enable*/
      file.uploading = false
      onChange(this.images)
    })

    this.uploader.on('uploadError', (file) => {
      file.uploading = false
      file.error = true
      onChange(this.images)
    })

    this.initialized = true
  }

  render() {
    return this.props.children
  }
}
