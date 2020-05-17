import React, { Component, PropTypes } from 'react'

function checkbox(name, checkedValues, onChange) {
  return (
    class Checkbox extends Component {
      static propTypes = {
        value: PropTypes.string
      }

      handleChange = (event) => {
        const value = event.currentTarget.value
        if (checkedValues.includes(this.props.value)) {
          onChange(checkedValues.filter((item) => item !== value))
        } else {
          onChange([...checkedValues, value])
        }
      }

      render() {
        const optional = {}
        if (checkedValues) {
          optional.checked = checkedValues.includes(this.props.value)
        }
        return (
          <input
            {...this.props}
            type="checkbox"
            name={name}
            onChange={this.handleChange}
            {...optional}
          />
        )
      }
    }
  )
}

export default class CheckboxGroup extends Component { // eslint-disable-line react/no-multi-comp
  static propTypes = {
    name: PropTypes.string,
    defaultValue: PropTypes.array,
    value: PropTypes.array,
    onChange: PropTypes.func,
    children: PropTypes.func.isRequired,
  }

  render() {
    const { name, defaultValue, value, onChange, children } = this.props
    const checkedValues = value || defaultValue || []
    const renderedChildren = children(checkbox(name, checkedValues, onChange))
    return renderedChildren && React.Children.only(renderedChildren)
  }
}
