import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Field, RegionSelectGroup, ProvinceSelect, CitySelect } from 'components'
import validation from './validation'
import { Input, Col } from 'antd'
const InputGroup = Input.Group

@reduxForm({
  form: 'shop',
  fields: ['id', 'name', 'address', 'phone', 'province', 'city'],
  validate: validation
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired
  }

  render() {
    const { fields } = this.props

    return (
      <div className="ui form">
        <Field className="required field" {...fields.name}>
          <label htmlFor="name">分店名称</label>
          <input id="name" type="text" {...fields.name} />
        </Field>
        <Field className="field" {...fields.phone}>
          <label htmlFor="name">联系电话</label>
          <input id="name" type="text" {...fields.phone} />
        </Field>
        <Field className="field">
          <label>所属城市</label>
          <RegionSelectGroup>
            <InputGroup>
              <Col span="12">
                <ProvinceSelect {...fields.province} />
              </Col>
              <Col span="12">
                <CitySelect {...fields.city} />
              </Col>
            </InputGroup>
          </RegionSelectGroup>
        </Field>
        <Field className="field" {...fields.address}>
          <label htmlFor="name">分店地址</label>
          <input id="name" type="text" {...fields.address} />
        </Field>
      </div>
    )
  }
}
