import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { reduxForm } from 'redux-form'
import { FormItem } from 'components'
import { Form as AntdForm, Checkbox } from 'antd'
const CheckboxGroup = Checkbox.Group
import styles from './style.scss'

const options = [
  { label: '楚车联盟', value: 'Apple1' },
  { label: '楚车联', value: 'Apple2' },
  { label: '楚车', value: 'Apple3' },
  { label: '楚车联盟', value: 'Apple4' },
  { label: '楚车联盟1', value: 'Apple5' },
  { label: '川车x联盟', value: 'Pear1' },
  { label: '川车', value: 'Pear2' },
  { label: '川车联盟', value: 'Pear3' },
  { label: '川车xx联盟', value: 'Pear4' },
  { label: '川车联盟', value: 'Pear5' },
  { label: '北京', value: 'Orange1' },
  { label: '北京联盟', value: 'Orange2' },
  { label: '北京xxx联盟', value: 'Orange3' },
  { label: '北京联盟', value: 'Orange4' },
  { label: '北京联盟1', value: 'Orange5' },
]

@reduxForm({
  form: 'allianceSelect',
  fields: ['allianceIds'],
})
export default class Form extends PureComponent {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired,
    options: PropTypes.array.isRequired,
  }

  handleToggleAll = (event) => {
    const selectedAll = event.target.checked
    const { allianceIds } = this.props.fields
    if (selectedAll) {
      const { options } = this.props
      const ids = options.map(option => option.value)
      allianceIds.onChange(ids)
    } else {
      allianceIds.onChange([])
    }
  }

  render() {
    const { car, fields, options } = this.props
    const checkAll = options.every(option => fields.allianceIds.value.includes(option.value))

    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 14 }
    }

    return (
      <AntdForm horizontal className={styles.alliancesSelect}>
        <FormItem {...formItemLayout} label="车辆名称：">
          <p className="ant-form-text">{car.systemName}</p>
        </FormItem>

        <div className={styles.selectAll}>
          将在以下联盟中展示
          <Checkbox defaultChecked={checkAll} onChange={this.handleToggleAll}>全选</Checkbox>
        </div>

        <div className={styles.alliances}>
          <CheckboxGroup options={options} {...fields.allianceIds} />
        </div>
      </AntdForm>
    )
  }
}
