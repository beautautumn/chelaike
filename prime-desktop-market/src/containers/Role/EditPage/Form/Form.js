import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import FirstColumn from './FirstColumn'
import SecondColumn from './SecondColumn'
import validation from './validation'
import { errorFocus } from 'decorators'
import { Segment } from 'components'
import { Row, Col, Button, Affix, Form as AForm } from 'antd'
import Helmet from 'react-helmet'
import styles from './Form.scss'

@reduxForm({
  form: 'role',
  fields: [
    'id', 'name', 'authorities', 'note'
  ],
  validate: validation
})
@errorFocus
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    handleCancel: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired
  }

  render() {
    const { handleSubmit, handleCancel, saving, fields } = this.props

    return (
      <Segment className="ui segment">
        <Helmet title={!fields.id.value ? '新增角色' : fields.name.value} />
        <AForm horizontal onSubmit={handleSubmit} className={styles.form}>
          <Row>
            <Col span="10">
              <Row>
                <FirstColumn {...this.props} />
              </Row>
              <Affix offsetTop={30}>
                <Row>
                  <Col span="10" offset="6">
                    <Button size="large" onClick={handleCancel}>返回</Button>
                    <Button
                      type="primary"
                      size="large"
                      htmlType="submit"
                      loading={saving}
                    >
                      保存
                    </Button>
                  </Col>
                </Row>
              </Affix>
            </Col>
            <Col span="6" offset="1">
              <SecondColumn {...this.props} />
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
