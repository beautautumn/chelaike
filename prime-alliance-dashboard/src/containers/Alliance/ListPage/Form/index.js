import React, { PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Row, Col, Button } from 'antd'
import { NumberInput } from '@prime/components'
import { Segment, FormItem, RegionSelectGroup, Select } from 'components'
import validation from './validation'
import styles from '../style.scss'
import LogoUploader from './LogoUploader'

function Form({ fields, handleSubmit, saving, oss, enumValues }) {
  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 },
  }

  return (
    <Segment>
      <AForm horizontal onSubmit={handleSubmit} className={styles.form}>
        <Row>
          <Col span="10">
            <FormItem {...formItemLayout} required label="联盟名称" field={fields.name}>
              <Input type="text" {...fields.name} />
            </FormItem>
            <FormItem {...formItemLayout} label="联系人">
              <Input type="text" {...fields.contact} />
            </FormItem>
            <FormItem {...formItemLayout} label="联系电话">
              <Input type="text" {...fields.contactMobile} />
            </FormItem>
            <RegionSelectGroup>
              <FormItem {...formItemLayout} label="省市">
                <Row>
                  <Col span="11">
                    <RegionSelectGroup.Province {...fields.province} />
                  </Col>
                  <Col span="12" offset="1">
                    <RegionSelectGroup.City {...fields.city} />
                  </Col>
                </Row>
              </FormItem>
            </RegionSelectGroup>
            <FormItem {...formItemLayout} label="详细地址">
              <Input type="text" {...fields.street} />
            </FormItem>
            <FormItem {...formItemLayout} label="联盟描述">
              <Input type="textarea" autosize rows={2} {...fields.note} />
            </FormItem>
          </Col>
          <Col span="13" offset="1">
            <LogoUploader title=" Logo" oss={oss} {...fields.avatar} />
            <LogoUploader title="水印" oss={oss} {...fields.waterMark}>
              <Row
                className={styles.watermarkContainer}
                type="flex"
                justify="space-between"
                align="bottom"
              >
                <Col span="11">
                  <FormItem field={fields.waterMarkPosition.p}>
                    <label>水印位置：</label>
                    <Select
                      size="default"
                      items={enumValues.water_mark_position}
                      {...fields.waterMarkPosition.p}
                    />
                  </FormItem>
                  <FormItem field={fields.waterMarkPosition.x}>
                    <label>水印横向边距：</label>
                    <NumberInput {...fields.waterMarkPosition.x} addonAfter="px" />
                  </FormItem>
                </Col>
                <Col span="11" offset="2">
                  <FormItem field={fields.waterMarkPosition.y}>
                    <label>水印竖向边距：</label>
                    <NumberInput {...fields.waterMarkPosition.y} addonAfter="px" />
                  </FormItem>
                </Col>
              </Row>
            </LogoUploader>
          </Col>
        </Row>
        <Row>
          <Col offset="11">
            <Button type="primary" size="large" loading={saving} onClick={handleSubmit}>保存</Button>
          </Col>
        </Row>
      </AForm>
    </Segment>
  )
}

Form.propTypes = {
  fields: PropTypes.object.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  saving: PropTypes.bool.isRequired,
  oss: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}

export default reduxForm({
  form: 'alliance',
  fields: [
    'id', 'name', 'contact', 'contactMobile',
    'province', 'city', 'street', 'avatar', 'note',
    'waterMark', 'waterMarkPosition.p', 'waterMarkPosition.x', 'waterMarkPosition.y',
  ],
  validate: validation,
})(Form)
