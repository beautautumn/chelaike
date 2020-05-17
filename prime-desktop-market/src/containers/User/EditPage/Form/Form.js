import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import FirstColumn from './FirstColumn'
import ThirdColumn from './ThirdColumn'
import validation from './validation'
import { errorFocus } from 'decorators'
import { Segment } from 'components'
import { Form, Row, Col } from 'antd'
import styles from './Form.scss'
import Helmet from 'react-helmet'

@reduxForm({
  form: 'user',
  fields: [
    'id', 'name', 'username', 'password', 'passwordConfirmation', 'phone',
    'email', 'managerId', 'state', 'authorityType', 'authorityRoleIds',
    'authorities', 'note', 'shopId', 'shopName', 'settings.macAddressLock', 'macAddress',
    'settings.deviceNumberLock', 'deviceNumbers', 'settings.crossShopRead',
    'settings.crossShopEdit', 'settings.crossShopReadStatistic',
    'isAllianceContact', 'state', 'needSmsNotice', 'companyId', 'companyName', 'userType',
    'viewItems'
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

  componentDidMount() {
    window.addEventListener('message', this.props.handleSubmit, false)
  }

  componentWillUpdate(nextProps) {
    if (!this.props.fields.viewItems.value ||
      this.props.fields.authorities !== nextProps.fields.authorities) {
      const viewItems = this.props.convertToViewItems(nextProps.fields.authorities.value)
      this.props.fields.viewItems.onChange(viewItems)
    }
  }

  componentWillUnmount() {
    window.removeEventListener('message', this.props.handleSubmit)
  }

  render() {
    const { fields, handleSubmit } = this.props

    return (
      <Segment className="ui segment">
        <Helmet title={!fields.id.value ? '新增员工' : fields.name.value} />
        <Form horizontal onSubmit={handleSubmit} className={styles.form}>
          <Row>
            <Col span="12">
              <Row>
                <FirstColumn {...this.props} />
              </Row>
            </Col>
            <Col span="11" offset="1">
              <ThirdColumn {...this.props} />
            </Col>
          </Row>
        </Form>
      </Segment>
    )
  }
}
