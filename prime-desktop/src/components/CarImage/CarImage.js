import React, { Component, PropTypes } from 'react'
import { scale } from 'helpers/image'
import placeholder from './placehoder.png'

export default class CarImage extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    className: PropTypes.string,
    width: PropTypes.number,
    height: PropTypes.number
  }

  static defaultProps = {
    width: 120,
    height: 80
  }

  render() {
    const { car, className, width, height } = this.props
    const coverUrl = car.coverUrl ? scale(car.coverUrl, `${width}x${height}`) : placeholder

    return (
      <img role="presentation" className={className} src={coverUrl} width={width} height={height} />
    )
  }
}
