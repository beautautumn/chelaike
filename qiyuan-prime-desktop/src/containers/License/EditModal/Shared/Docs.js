import React, { Component, PropTypes } from 'react'
import { Row, Col, Checkbox, Input } from 'antd'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import styles from '../EditModal.scss'


function Item({ item, field }) {
  const className = item.required ? styles.required : null
  const isChecked = field.value && field.value.includes(item.key)

  const onChange = (event) => {
    const value = event.target.value
    const checkedValues = field.value
    if (checkedValues.includes(value)) {
      field.onChange(checkedValues.filter((item) => item !== value))
    } else {
      field.onChange([...checkedValues, value])
    }
  }

  return (
    <Col span="5">
      <label className={className}>
        <Checkbox value={item.key} checked={isChecked} onChange={onChange} />
        {item.text}
      </label>
    </Col>
  )
}

const fields = ['items', 'contactPerson', 'contactMobile']

@formOptimize(fields)
class Docs extends Component {
  static propTypes = {
    formItemLayout: PropTypes.object.isRequired,
    items: PropTypes.array.isRequired,
    fields: PropTypes.object.isRequired
  }

  render() {
    const { formItemLayout, items, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>手续信息</div>
        <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 21 }} label="手续资料：">
          {items.map((item) => (
            <Item key={item.key} item={item} field={fields.items} />
          ))}
        </FormItem>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="手续联系人：">
              <Input {...fields.contactPerson} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="联系电话：" field={fields.contactMobile}>
              <Input {...fields.contactMobile} />
            </FormItem>
          </Col>
        </Row>
      </div>
    )
  }
}

Docs.fields = fields

export default Docs
