import React, { Component, PropTypes } from 'react'
import { CooperationCompanySelect, FormItem } from 'components'
import { Row, Col, Button, Icon } from 'antd'
import { NumberInput } from '@prime/components'
import styles from '../EditPage.scss'

export default class CooperationCompanyForm extends Component {
  static propTypes = {
    onChange: PropTypes.func,
    defaultValue: PropTypes.array,
    value: PropTypes.array
  }

  constructor(props) {
    super(props)

    this.state = {
      relations: props.value || props.defaultValue || []
    }
  }

  handleAdd = () => {
    this.setState({
      relations: [
        ...this.state.relations,
        { cooperationCompanyId: null, cooperationPriceWan: null }
      ]
    }, () => this.props.onChange(this.state.relations))
  }

  handleRemove = (index) => () => {
    this.state.relations[index]._destroy = true // eslint-disable-line
    this.setState({
      relations: this.state.relations
    }, () => this.props.onChange(this.state.relations))
  }

  handleChange = (index, field) => (eventOrValue) => {
    const value = eventOrValue.currentTarget ? eventOrValue.currentTarget.value : eventOrValue
    this.state.relations[index][field] = value
    this.setState({
      relations: this.state.relations
    }, () => this.props.onChange(this.state.relations))
  }

  render() {
    const { relations } = this.state

    return (
      <Row>
        <Col span="2" className={styles.labelCol}>合作商家：</Col>
        <Col span="22">
          {relations.map((relation, index) => {
            if (relation._destroy) { // eslint-disable-line
              return null
            }
            return (
              <FormItem key={index}>
                <Row>
                  <Col span="11">
                    <CooperationCompanySelect
                      value={relation.cooperationCompanyId}
                      onChange={this.handleChange(index, 'cooperationCompanyId')}
                    />
                  </Col>
                  <Col span="4" offset="1">
                    <NumberInput
                      value={relation.cooperationPriceWan}
                      onChange={this.handleChange(index, 'cooperationPriceWan')}
                      addonAfter="万元"
                    />
                  </Col>
                  <Col span="2" offset="1">
                    <Button type="primary" size="large" onClick={this.handleRemove(index)}>
                      <Icon type="minus" />
                    </Button>
                  </Col>
                </Row>
              </FormItem>
            )
          })}
          <Button size="large" onClick={this.handleAdd}>
            <Icon type="plus" />
          </Button>
        </Col>
      </Row>
    )
  }
}
