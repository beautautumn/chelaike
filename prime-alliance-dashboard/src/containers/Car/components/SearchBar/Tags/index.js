import React, { Component, PropTypes } from 'react'
import { Tag, Popover, Col, Input, Button, Icon } from 'antd'
import { NumberInput } from '@prime/components'
import pick from 'lodash/pick'
import isEqual from 'lodash/isEqual'
import isEmpty from 'lodash/isEmpty'
import cx from 'classnames'
import styles from '../style.scss'

export default class Tags extends Component {
  static propTypes = {
    query: PropTypes.object.isRequired,
    label: PropTypes.string.isRequired,
    filters: PropTypes.array.isRequired,
    keys: PropTypes.array.isRequired,
    customInput: PropTypes.bool,
    unit: PropTypes.string,
    handleClick: PropTypes.func.isRequired,
    children: PropTypes.object,
  }

  constructor(props) {
    super(props)

    this.state = {
      visible: false,
      customInput: {},
      customInputPrepare: {},
    }

    this.blankValue = props.keys.reduce((acc, key) => ({ ...acc, [key]: undefined }), {})
  }

  componentWillReceiveProps(nextProps) {
    const { query, keys } = nextProps
    // 不是自定义的
    if (!isEqual(pick(query, keys), this.state.customInput)) {
      this.setState({ customInput: {} })
    }
  }

  handleCustomInputChange = key => event => {
    this.setState({
      customInputPrepare: {
        ...this.state.customInputPrepare,
        [key]: event.target.value,
      },
    })
  }

  handleCustomSubmit = () => {
    const { handleClick } = this.props
    this.setState({
      customInput: { ...this.state.customInputPrepare },
    }, () => { handleClick(this.state.customInput)() })
    this.setState({ visible: false })
  }

  handleCustomInputClear = () => {
    this.setState({ customInput: {} }, this.props.handleClick(this.blankValue))
  }

  handleVisibleChange = (visible) => {
    this.setState({ visible })
  }

  selected(query, condition) {
    const picked = pick(query, Object.keys(condition))
    return isEqual(picked, condition)
  }

  renderCustomInput() {
    const { keys, unit } = this.props
    return (
      <Input.Group className={styles.customInputGroup}>
        <Col span="8">
          <NumberInput onChange={this.handleCustomInputChange(keys[0])} />
        </Col>
        <Col span="11">
          <NumberInput addonAfter={unit} onChange={this.handleCustomInputChange(keys[1])} />
        </Col>
        <Button type="primary" htmlType="submit" onClick={this.handleCustomSubmit}>确定</Button>
      </Input.Group>
    )
  }

  renderCustomTag() {
    const { customInput } = this.state
    const { keys, unit } = this.props
    const gtPredicate = customInput[keys[0]]
    const ltPredicate = customInput[keys[1]]
    let content
    if (gtPredicate && ltPredicate) {
      content = `${gtPredicate}-${ltPredicate}${unit}`
    } else if (gtPredicate) {
      content = `${gtPredicate}${unit}以上`
    } else if (ltPredicate) {
      content = `${ltPredicate}${unit}内`
    }
    return <Tag key="custom" color="blue" onClick={this.handleCustomInputClear}>{content}</Tag>
  }

  renderTags() {
    const { query, filters, keys, customInput, handleClick, children } = this.props
    const buttons = filters.map((filter, index) => {
      const condition = keys.reduce((acc, key, ix) => ({
        ...acc,
        [key]: filter[ix],
      }), {})
      const selected = this.selected(query, condition)

      if (selected) {
        return (
          <Tag key={index} color="blue" onClick={handleClick(this.blankValue)}>
            {filter[2]}
          </Tag>
        )
      }

      return (
        <a href="#" className={styles.tag} key={index} onClick={handleClick(condition)}>
          {filter[2]}
        </a>
      )
    })
    if (customInput) {
      if (!this.state.visible && !isEmpty(this.state.customInput)) {
        buttons.push(this.renderCustomTag())
      } else {
        const content = this.renderCustomInput()
        buttons.push(
          <Popover
            key="custom"
            placement="topLeft"
            content={content}
            trigger="click"
            visible={this.state.visible}
            onVisibleChange={this.handleVisibleChange}
          >
            <a className={cx(styles.tag, styles.custom)}>
              自定义<Icon type="down" />
            </a>
          </Popover>
        )
      }
    }

    if (children) {
      buttons.push(children)
    }
    return buttons
  }

  render() {
    const { label } = this.props

    return (
      <tr>
        <td className={styles.label}>{label}</td>
        <td className={styles.input}>
          {this.renderTags()}
        </td>
      </tr>
    )
  }
}
