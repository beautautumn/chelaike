import React, { Component, PropTypes } from 'react'
import CarImage from '../CarImage/CarImage'

export default class CarListImage extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    showLabel: PropTypes.bool
  }

  static defaultProps = {
    showLabel: true
  }

  render() {
    const { car } = this.props

    return (
      <CarImage car={car} />
    )
  }
}
