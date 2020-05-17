import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Row, Col, Button } from 'antd'
import { Segment, FormActions } from 'components'
import FirstColumn from './FirstColumn'
import SecondColumn from './SecondColumn'
import ThirdColumn from './ThirdColumn'
import find from 'lodash/find'
import uniq from 'lodash/uniq'
import validation from './validation'

@reduxForm({
  form: 'user',
  fields: [
    'id', 'name', 'username', 'password', 'passwordConfirmation', 'phone',
    'email', 'managerId', 'state', 'authorityType', 'authorityRoleIds',
    'authorities', 'note',
  ],
  validate: validation,
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    roles: PropTypes.array.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    handleCancel: PropTypes.func.isRequired,
  }

  handleRoleChange = value => {
    const { fields } = this.props
    fields.authorities.onChange(this.selectedAuthorities(value))
    fields.authorityRoleIds.onChange(value)
  }

  selectedAuthorities(rolesId) {
    let authorities = []
    rolesId.forEach((roleId) => {
      const role = find(this.props.roles, (r) => r.id === roleId) // eslint-disable-line id-length
      authorities = uniq(authorities.concat(role.authorities))
    })
    return authorities
  }

  render() {
    const { handleSubmit, handleCancel } = this.props

    return (
      <Segment className="ui segment">
        <AForm horizontal onSubmit={handleSubmit}>
          <Row>
            <Col span="17">
              <Row>
                <FirstColumn {...this.props} />
                <SecondColumn {...this.props} handleRoleChange={this.handleRoleChange} />
              </Row>
              <Row>
                <Col span="10" offset="3">
                  <FormActions>
                    <Button type="primary" size="large" htmlType="submit">保存</Button>
                    <Button size="large" onClick={handleCancel}>返回</Button>
                  </FormActions>
                </Col>
              </Row>
            </Col>
            <Col span="6" offset="1">
              <ThirdColumn {...this.props} />
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
