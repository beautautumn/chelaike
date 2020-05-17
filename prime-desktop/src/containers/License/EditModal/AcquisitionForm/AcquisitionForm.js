import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form } from 'antd'
import items from './items'
import { errorFocus } from 'decorators'
import CurrentInfo from './Forms/CurrentInfo'
import OtherInfo from './Forms/OtherInfo'
import State from '../Shared/State'
import Docs from '../Shared/Docs'
import CarInfo from '../Shared/CarInfo'
import validation from './validation'

@reduxForm({
  form: 'acquisitionLicense',
  fields: [
    CurrentInfo, OtherInfo, State, Docs, CarInfo
  ].reduce((acc, form) => acc.concat(form.fields), []),
  validate: validation,
})
@errorFocus
export default class AcquisitionForm extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    formItemLayout: PropTypes.object.isRequired,
  }

  render() {
    const { fields, car, enumValues, formItemLayout } = this.props

    return (
      <Form horizontal>
        <State
          formItemLayout={formItemLayout}
          car={car}
          enumValues={enumValues}
          fields={fields}
        />
        <Docs
          formItemLayout={formItemLayout}
          items={items}
          fields={fields}
        />
        <CarInfo
          title="原车"
          enumValues={enumValues}
          formItemLayout={formItemLayout}
          fields={fields}
        />
        <CurrentInfo
          formItemLayout={formItemLayout}
          fields={fields}
        />
        <OtherInfo
          formItemLayout={formItemLayout}
          fields={fields}
        />
      </Form>
    )
  }
}
