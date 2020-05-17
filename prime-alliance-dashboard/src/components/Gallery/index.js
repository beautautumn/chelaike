import React, { Component, PropTypes } from 'react'
import { ImageGallery } from 'react-responsive-carousel'
import { scale } from 'helpers/image'
import 'react-responsive-carousel/lib/styles/imageGallery.css'
import 'react-responsive-carousel/lib/styles/carousel.css'
import './style.scss'

export default class Gallery extends Component {
  static propTypes = {
    images: PropTypes.array,
    defaultImage: PropTypes.string,
  }

  handleZoom = (index) => {
    const { images } = this.props
    window.open(images[index].url)
  }

  render() {
    const { images, defaultImage } = this.props

    let gallery
    if (images && images.length > 0) {
      gallery = (
        <ImageGallery showStatus showControls onZoom={this.handleZoom}>
          {images.map((image, index) => (
            <img key={index} role="presentation" src={scale(image.url, '534x340')} />
          ))}
        </ImageGallery>
      )
    } else {
      const image = require(`./${defaultImage}.png`) // eslint-disable-line global-require
      gallery = (
        <img role="presentation" src={image} />
      )
    }

    return gallery
  }
}
