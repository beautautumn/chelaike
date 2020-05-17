import React, { Component, PropTypes } from 'react'
import AutosizeInput from 'react-input-autosize'
import classnames from 'classnames'
import styles from './InlineEdit.scss'

export default class InlineEdit extends Component {
  static propTypes = {
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.number,
    ]),
    onChange: PropTypes.func,
    onBlur: PropTypes.func,
    onEnter: PropTypes.func,
  }

  static defaultProps = {
    onChange: () => {},
    onBlur: () => {},
    onEnter: () => {},
  }

  constructor(props) {
    super(props)

    this.state = {
      editing: false,
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.editing === false && this.state.editing === true) {
      this.input.refs.input.focus()
    }
  }

  handleClick = () => {
    this.setState({ editing: true })
  }

  handleChange = e => {
    this.props.onChange(e)
  }

  handleBlur = () => {
    this.setState({ editing: false }, this.props.onBlur)
  }

  handlePress = e => {
    if (e.key === 'Enter') {
      this.setState({ editing: false }, this.props.onEnter)
    }
  }

  render() {
    const { editing } = this.state
    const value = this.props.value || ''

    if (editing) {
      return (
        <AutosizeInput
          ref={ref => (this.input = ref)}
          value={value}
          onChange={this.handleChange}
          onBlur={this.handleBlur}
          onKeyPress={this.handlePress}
          minWidth={10}
        />
      )
    }

    const className = classnames({
      [styles.text]: true,
      [styles.placeholder]: !value,
    })

    return <span className={className} onClick={this.handleClick}>{value || '编辑'}</span>
  }
}
