import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { ImageManager } from 'components'
import { Form } from 'antd'

@reduxForm({
  form: 'acquisitionLicense',
  fields: ['imagesAttributes']
})
export default class ImagesForm extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    oss: PropTypes.object
  }

  render() {
    const { fields: { imagesAttributes }, oss } = this.props
    const tranferLocations = [
      '行驶证',
      '登记证',
      '车辆牌照',
      '原始发票',
      '购置税',
      '原车主身份证',
      '买主身份证',
      '铭牌',
      '其他资料'
    ]

    return (
      <Form horizontal>
        <ImageManager
          oss={oss}
          locations={tranferLocations}
          hasCover={false}
          {...imagesAttributes}
        />
      </Form>
    )
  }
}
