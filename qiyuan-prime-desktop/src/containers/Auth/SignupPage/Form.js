import React, { Component, PropTypes } from 'react'
import { Segment, RegionSelectGroup, ProvinceSelect, CitySelect, Field } from 'components'
import { reduxForm } from 'redux-form'
import { errorFocus } from 'decorators'
import validation from './validation'

@reduxForm({
  form: 'signup',
  fields: [
    'company.province', 'company.city', 'company.contact', 'company.name',
    'company.marketArea',
    'user.phone', 'user.name', 'user.password', 'user.confirmPassword'
  ],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    registering: PropTypes.bool
  }

  constructor(props) {
    super(props)

    this.state = { agreeToTos: false }
  }

  handleTos = () => {
    this.setState({ agreeToTos: !this.state.agreeToTos })
  }

  handleShowTos = (event) => {
    event.preventDefault()
    this.props.showModal('tos')
  }

  render() {
    const { fields, handleSubmit, registering } = this.props
    const { agreeToTos } = this.state

    return (
      <div>
        <form className="ui form">
          <Segment className="ui left aligned segment">
            <Field className="required field" {...fields.company.name}>
              <label htmlFor="name">市场名称</label>
              <input
                id="name"
                type="text"
                placeholder="请填写市场全称，以免造成审核不通过"
                {...fields.company.name}
              />
            </Field>

            <Field className="required field" {...fields.company.marketArea}>
              <label htmlFor="name">市场面积</label>
              <input
                id="name"
                type="text"
                placeholder="请填写市场面积"
                {...fields.company.marketArea}
              />
            </Field>

            <Field className="required field" {...fields.company.contact}>
              <label htmlFor="contact">联系人</label>
              <input
                id="contact"
                type="text"
                placeholder="请填写市场负责联系人姓名"
                {...fields.company.contact}
              />
            </Field>

            <Field className="required field" {...fields.user.phone}>
              <label htmlFor="phone">手机号码</label>
              <input
                id="phone"
                type="text"
                placeholder="该号码即为市场管理员登录账号" {...fields.user.phone}
              />
            </Field>

            <Field className="required field" {...fields.user.password}>
              <label htmlFor="password">密码</label>
              <input
                id="password"
                type="password"
                placeholder="最短6位，区分大小写"
                {...fields.user.password}
              />
            </Field>

            <Field className="required field" {...fields.user.confirmPassword}>
              <label htmlFor="passwordConfirmation">确认密码</label>
              <input
                id="passwordConfirmation"
                type="password"
                {...fields.user.confirmPassword}
              />
            </Field>

            <div className="field required">
              <label htmlFor="province">地区</label>
              <RegionSelectGroup>
                <div className="two fields">
                  <Field className="field" {...fields.company.province}>
                    <ProvinceSelect {...fields.company.province} />
                  </Field>
                  <Field className="field" {...fields.company.city}>
                    <CitySelect {...fields.company.city} />
                  </Field>
                </div>
              </RegionSelectGroup>
            </div>

            <div className="inline field">
              <div className="ui checkbox">
                <input
                  id="agreeToTos"
                  type="checkbox"
                  value={agreeToTos}
                  onChange={this.handleTos}
                />
                <label htmlFor="agree-to-tos">
                  我同意遵守《 <a href="" onClick={this.handleShowTos}> 车来客服务协议</a>》
                </label>
              </div>
            </div>
            <button
              className="ui fluid large teal submit button"
              onClick={handleSubmit}
              disabled={!agreeToTos || registering}
            >
              {registering ? '注册中...' : '注册'}
            </button>
          </Segment>
        </form>
      </div>
    )
  }
}
