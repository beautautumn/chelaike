import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import validation from './validation'
import { RegionSelectGroup, ProvinceSelect, CitySelect, Field } from 'components'
import LogoUploader from './LogoUploader/LogoUploader'
import FacadeUploader from './FacadeUploader/FacadeUploader'
import Textarea from 'react-textarea-autosize'
import { errorFocus } from 'decorators'

@reduxForm({
  form: 'company',
  fields: [
    'id', 'contact', 'contactMobile', 'acquisitionMobile', 'saleMobile', 'logo',
    'province', 'city', 'street', 'name', 'note', 'facade'
  ],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    oss: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired
  }

  render() {
    const { oss, fields, handleSubmit, saving } = this.props

    return (
      <div className="eight wide column">
        <form className="ui form" onSubmit={handleSubmit}>
          <Field className="required field" {...fields.name}>
            <label htmlFor="name">公司名称</label>
            <input id="name" type="text" {...fields.name} />
          </Field>
          <div className="field">
            <label htmlFor="contact">联系人</label>
            <input id="contact" type="text" {...fields.contact} />
          </div>
          <div className="field">
            <label htmlFor="contactMobile">公司电话</label>
            <input id="contactMobile" type="text" {...fields.contactMobile} />
          </div>
          <div className="field">
            <label htmlFor="acquisitionMobile">收购电话</label>
            <input id="acquisitionMobile" type="text" {...fields.acquisitionMobile} />
          </div>
          <div className="field">
            <label htmlFor="saleMobile">销售电话</label>
            <input id="saleMobile" type="text" {...fields.saleMobile} />
          </div>

          <LogoUploader oss={oss} {...fields.logo} />

          <FacadeUploader oss={oss} {...fields.facade} />

          <div className="field">
            <label>地区</label>
            <RegionSelectGroup>
              <div className="two fields">
                <div className="field">
                  <ProvinceSelect {...fields.province} />
                </div>
                <div className="field">
                  <CitySelect {...fields.city} />
                </div>
              </div>
            </RegionSelectGroup>
          </div>
          <div className="field">
            <input id="street" type="text" {...fields.street} />
          </div>

          <div className="field">
            <label htmlFor="note">公司描述</label>
            <Textarea id="note" rows={4} {...fields.note} />
          </div>

          <button className="ui blue button" type="submit" disabled={saving}>
            {saving ? '保存中...' : '保存'}
          </button>
        </form>
      </div>
    )
  }
}
