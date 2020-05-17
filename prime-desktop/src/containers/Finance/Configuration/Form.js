import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Button, Row, Col, Radio } from 'antd'
import { FormItem, Segment } from 'components'
import validation from './validation'

@reduxForm({
  form: 'financeConfiguration',
  fields: [
    'fundRate', 'gearing', 'rent', 'area', 'rentBy'
  ],
  validate: validation,
})
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
  }

  render() {
    const { fields, handleSubmit } = this.props

    const formItemLayout = {
      labelCol: { span: 5 },
      wrapperCol: { span: 12 },
    }

    return (
      <Segment>
        <AForm onSubmit={handleSubmit} horizontal>
          <FormItem {...formItemLayout} label="单车资金利率：" field={fields.fundRate} required >
            <Input {...fields.fundRate} addonAfter="%/月" />
          </FormItem>
          <FormItem {...formItemLayout} label="融资比例：" field={fields.gearing} required >
            <Input {...fields.gearing} addonAfter="%" />
          </FormItem>
          <FormItem {...formItemLayout} label="场租成本：" required >
            <Input.Group>
              <Col span="24">
                <Radio.Group {...fields.rentBy}>
                  <Radio key="area" value="area">按面积</Radio>
                  <Radio key="unit" value="unit">按车位</Radio>
                </Radio.Group>
              </Col>
              {fields.rentBy.value === 'area' &&
                <Col span="8">
                  <FormItem field={fields.rent} >
                    <Input {...fields.rent} addonAfter="元/每平米每天" />
                  </FormItem>
                </Col>
              }
              {fields.rentBy.value === 'area' &&
                <Col offset="1" span="9">
                  <FormItem field={fields.area} >
                    <Input {...fields.area} addonBefore="核算面积" addonAfter="平米" />
                  </FormItem>
                </Col>
              }
              {fields.rentBy.value === 'unit' &&
                <Col span="8">
                  <FormItem field={fields.rent} >
                    <Input {...fields.rent} addonAfter="元/每个每年" />
                  </FormItem>
                </Col>
              }
              {fields.rentBy.value === 'unit' &&
                <Col offset="1" span="9">
                  <FormItem field={fields.area} >
                    <Input {...fields.area} addonBefore="车位共" addonAfter="个" />
                  </FormItem>
                </Col>
              }
            </Input.Group>
          </FormItem>
          <Row>
            <Col span="17">
              <Button type="primary" size="large" htmlType="submit" style={{ float: 'right' }} >
                保存
              </Button>
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
