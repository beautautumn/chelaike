import React, { Component, PropTypes } from 'react'
import { Row, Checkbox, Switch } from 'antd'
import { FormItem } from 'components'
import { formOptimize } from 'decorators'
import Textarea from 'react-textarea-autosize'
import styles from './Form.scss'
import { Element } from 'react-scroll'
const CheckboxGroup = Checkbox.Group

const fields = [
  'car.interiorNote',
  'car.feeDetail',
  'car.attachments',
]

@formOptimize(fields)
class Description extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
  }

  handleSelectAllSwitch = (checked) => {
    const value = checked ? Object.keys(this.props.enumValues.car.attachments) : []
    this.props.fields.car.attachments.onChange(value)
  }

  render() {
    const attachEnum = this.props.enumValues.car.attachments
    const { interiorNote, attachments } = this.props.fields.car

    const options = Object.keys(attachEnum).map(key => ({ label: attachEnum[key], value: key }))
    const isSelectAll = Object.keys(attachEnum).every(key => attachments.value.includes(key))
    return (
      <Element name="description" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>车辆描述</div>
        <Row>
          <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="车辆附件：">
            <div className={styles.attachments}>
              <span>
                <label>全选</label>
                <Switch checked={isSelectAll} onChange={this.handleSelectAllSwitch} />
              </span>
              <CheckboxGroup options={options} {...attachments} />
            </div>
          </FormItem>
          <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 21 }} label="瑕疵描述：">
            <Textarea
              className="ant-input ant-input-lg"
              rows={8}
              placeholder="仅供内部使用"
              {...interiorNote}
            />
          </FormItem>
        </Row>
      </Element>
    )
  }
}

Description.fields = fields

export default Description
