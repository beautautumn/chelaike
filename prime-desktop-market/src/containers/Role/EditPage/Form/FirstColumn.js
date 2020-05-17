import React from 'react'
import { Input, Col } from 'antd'
import { FormItem } from 'components'
import styles from './Form.scss'

const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 16 }
}

export default ({ fields }) => (
  <Col span="24" className={styles.firstColumn}>
    <FormItem {...formItemLayout} required label="角色名称：" field={fields.name} >
      <Input id="name" type="text" {...fields.name} />
    </FormItem>

    <FormItem {...formItemLayout} label="角色备注：">
      <Input id="note" type="textarea" rows={4} {...fields.note} />
    </FormItem>
  </Col>
)
