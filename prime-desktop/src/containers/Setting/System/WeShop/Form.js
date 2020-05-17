import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { shallowEqual } from 'react-pure-render'
import BannerButton from './BannerButton'
import QrcodeButton from './QrcodeButton'

@reduxForm({
  form: 'weshop',
  fields: ['banners', 'qrcode']
})
export default class Form extends Component {
  static propTypes = {
    oss: PropTypes.object,
    fields: PropTypes.object,
    values: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.count = 0
  }

  componentDidUpdate(prevProps) {
    this.count += 1
    // 忽略第一次变化
    if (this.count <= 1) { return }
    if (!shallowEqual(this.props.values, prevProps.values)) {
      this.props.handleSubmit()
    }
  }

  render() {
    const { oss, fields } = this.props

    return (
      <div className="ui form">
        <div className="field">
          <label>轮播图片</label>
          <BannerButton oss={oss} {...fields.banners} />
        </div>

        <div className="field">
          <label>二维码</label>
          <QrcodeButton oss={oss} {...fields.qrcode} />
        </div>
      </div>
    )
  }
}
