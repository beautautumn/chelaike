import React, { Component, PropTypes } from 'react'
import isEmpty from 'lodash/isEmpty'
import set from 'lodash/set'
import cloneDeep from 'lodash/cloneDeep'
import deepEqual from 'deep-equal'
import { Row, Alert, Collapse } from 'antd'
import Field from './Field'

const Panel = Collapse.Panel

export default class Inputs extends Component {
  static propTypes = {
    defaultValue: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    onChange: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    const { defaultValue, value } = props
    this.features = value || defaultValue || []
    this.features.forEach((group) => {
      group.fields.forEach((field) => {
        if (typeof field.present === 'undefined') {
          if (field.type === 'select') {
            field.present = field.value === '标配'
          } else {
            field.present = !!field.value
          }
        }
      })
    })
  }

  componentWillReceiveProps(nextProps) {
    const { defaultValue, value } = nextProps
    this.features = value || defaultValue || []
  }

  shouldComponentUpdate(nextProps) {
    return !deepEqual(this.props.value, nextProps.value)
  }

  handleChange = (field, fieldValue) => {
    this.features = set(cloneDeep(this.features), field, fieldValue)
    this.props.onChange(this.features)
  }

  render() {
    if (isEmpty(this.features)) {
      return (
        <Row>
          <Alert message="请先选择车辆款式" type="info" showIcon />
        </Row>
      )
    }

    return (
      <Collapse defaultActiveKey="0" accordion>
        {this.features.map((group, groupIndex) => (
          <Panel key={groupIndex} header={group.name}>
            <Row>
              {group.fields.map((field, fieldIndex) => (
                <Field
                  key={fieldIndex}
                  groupName={group.name}
                  field={field}
                  fieldPath={`[${groupIndex}].fields[${fieldIndex}]`}
                  onChange={this.handleChange}
                />
              ))}
            </Row>
          </Panel>
        ))}
      </Collapse>
    )
  }
}
