import React, { Component, PropTypes } from 'react'
import { Col, Input, Checkbox } from 'antd'
import { FormItem } from 'components'
import FeatureInput from './FeatureInput'

function isReadOnly(groupName) {
  return ['基本参数', '车身', '发动机', '变速箱'].includes(groupName)
}

export default class FeatureField extends Component {
  static propTypes = {
    groupName: PropTypes.string.isRequired,
    field: PropTypes.object.isRequired,
    path: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired
  }

  render() {
    const { groupName, field, path, onChange } = this.props

    if (isReadOnly(groupName)) {
      return (
        <Col span="8">
          <FormItem labelCol={{ span: 8 }} wrapperCol={{ span: 16 }} label={field.name + '：'}>
            <Input disabled value={field.value} />
          </FormItem>
        </Col>
      )
    }
    return (
      <Col span="10" offset="1">
        <FormItem>
          <Col span="11" style={{ height: '33px' }}>
            <Checkbox
              checked={field.present}
              onChange={event => onChange(path, 'present', event.target.checked)}
            >
              {field.name}
            </Checkbox>
          </Col>
          <Col span="1" />
          <Col span="12">
            <FeatureInput
              field={field}
              path={path}
              onChange={onChange}
            />
          </Col>
        </FormItem>
      </Col>
    )
  }
}
