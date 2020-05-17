import React, { Component } from 'react'

export default class NumberInput extends Component {
  componentDidMount() {
    // http://stackoverflow.com/a/14810932/398988
    this.refs.input.addEventListener('mousewheel', () => this.refs.input.blur())
  }

  render() {
    return (
      <input ref="input" type="number" {...this.props} />
    )
  }
}
