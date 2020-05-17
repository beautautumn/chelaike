import React, { Component, PropTypes } from 'react'
import isEmpty from 'lodash/isEmpty'
import get from 'lodash/get'
import cloneDeep from 'lodash/cloneDeep'
import deepEqual from 'deep-equal'
import { Row, Alert, Collapse } from 'antd'
import FeatureField from './FeatureField'
const Panel = Collapse.Panel

export default class FeaturesInput extends Component {
  static propTypes = {
    defaultValue: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    onChange: PropTypes.func.isRequired
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

  handleChange = (path, field, value) => {
    this.features = cloneDeep(this.features)
    const feature = get(this.features, path)
    if (field === 'present') {
      feature.present = value
      if (value && !feature.value) {
        feature.value = '标配'
      }
    } else {
      feature[field] = value
    }
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
                <FeatureField
                  key={fieldIndex}
                  groupName={group.name}
                  field={field}
                  path={`[${groupIndex}].fields[${fieldIndex}]`}
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
