import React, { Component, PropTypes } from 'react'
import { scale } from 'helpers/image'
import placeholder from './placehoder.png'

export default class CarImage extends Component {
  static propTypes = {
    url: PropTypes.string,
    className: PropTypes.string,
    width: PropTypes.number,
    height: PropTypes.number,
  }

  static defaultProps = {
    width: 120,
    height: 80,
  }

  render() {
    const { url, className, width, height } = this.props
    const scaledUrl = url ? scale(url, `${width}x${height}`) : placeholder

    return (
      <img
        role="presentation"
        className={className}
        src={scaledUrl}
        width={width}
        height={height}
      />
    )
  }
}
