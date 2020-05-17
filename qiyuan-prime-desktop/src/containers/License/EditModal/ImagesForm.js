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
      { key: 'registration_license', label: '登记证' },
      { key: 'insurance', label: '保单' },
      { key: 'driving_license', label: '行驶证' },
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
