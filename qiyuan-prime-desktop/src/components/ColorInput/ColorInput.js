import React, { Component, PropTypes } from 'react'
import cx from 'classnames'
import styles from './ColorInput.scss'
import { Input } from 'antd'

export default class ColorInput extends Component {
  static propTypes = {
    colors: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.state = { show: false }
  }

  handleSelect = color => () => {
    this.props.onChange(color)
    this.hoveringColors = false
    this.handleBlur()
  }

  handleFocus = () => {
    this.setState({ show: true })
  }

  handleBlur = () => {
    if (!this.hoveringColors) {
      this.setState({ show: false })
    }
  }

  handleMouseOver = () => {
    this.hoveringColors = true
  }

  handleMouseOut = () => {
    this.hoveringColors = false
  }

  renderColorList() {
    const { colors } = this.props
    return Object.keys(colors).map((color, index) => {
      const hex = colors[color]
      return (
        <li key={index} onClick={this.handleSelect(color)}>
          <a className="ui empty circular label icon" style={{ backgroundColor: `#${hex}` }}></a>
          {color}
        </li>
      )
    })
  }

  renderColors() {
    const { show } = this.state
    return (
      <ul
        className={cx(styles.colors, { [styles.show]: show })}
        onMouseOver={this.handleMouseOver}
        onMouseOut={this.handleMouseOut}
      >
        {this.renderColorList()}
      </ul>
    )
  }

  render() {
    const { show } = this.state
    return (
      <div className={styles.colorInput}>
        <Input
          {...this.props}
          type="text"
          placeholder={show ? '若无以下颜色请手动输入' : ''}
          onFocus={this.handleFocus}
          onBlur={this.handleBlur}
        />
        {this.renderColors()}
      </div>
    )
  }
}
