import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import FirstColumn from './FirstColumn'
import SecondColumn from './SecondColumn'
import ThirdColumn from './ThirdColumn'
import validation from './validation'
import { errorFocus } from 'decorators'
import { Segment } from 'components'
import { Form, Row, Col, Button, Affix } from 'antd'
import styles from './Form.scss'
import Helmet from 'react-helmet'

@reduxForm({
  form: 'user',
  fields: [
    'id', 'name', 'username', 'password', 'passwordConfirmation', 'phone',
    'email', 'managerId', 'state', 'authorityType', 'authorityRoleIds',
    'authorities', 'note', 'shopId', 'settings.macAddressLock', 'macAddress',
    'settings.deviceNumberLock', 'deviceNumbers', 'settings.crossShopRead',
    'settings.crossShopEdit', 'settings.crossShopReadStatistic',
    'isAllianceContact', 'state'
  ],
  validate: validation
})
@errorFocus
export default class EditForm extends Component {
  static propTypes = {
    roles: PropTypes.array.isRequired,
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired
  }

  render() {
    const { handleSubmit, handleCancel, fields } = this.props

    return (
      <Segment className="ui segment">
        <Helmet title={!fields.id.value ? '新增员工' : fields.name.value} />
        <Form horizontal onSubmit={handleSubmit} className={styles.form}>
          <Row>
            <Col span="17">
              <Row>
                <FirstColumn {...this.props} />
                <SecondColumn {...this.props} />
              </Row>
              <Affix offsetTop={30}>
                <Row>
                  <Col span="10" offset="3">
                    <Button size="large" onClick={handleCancel}>返回</Button>
                    <Button type="primary" size="large" htmlType="submit">保存</Button>
                  </Col>
                </Row>
              </Affix>
            </Col>
            <Col span="6" offset="1">
              <ThirdColumn {...this.props} />
            </Col>
          </Row>
        </Form>
      </Segment>
    )
  }
}
