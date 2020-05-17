import React, { Component, PropTypes } from 'react'
import update from 'immutability-helper'
import { Row, Col } from 'antd'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'
import UploadButton from './UploadButton'
import Image from './Image'
import pick from 'lodash/pick'
import findIndex from 'lodash/findIndex'

function extractImageAttr(image) {
  return pick(
    image,
    'url',
    'preview',
    'uploading',
    'location',
    'isCover',
    '_destroy',
    'uuid',
    'error'
  )
}

@DragDropContext(HTML5Backend) // eslint-disable-line
export default class ImageManager extends Component {
  static propTypes = {
    oss: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    defaultValue: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.array,
    ]),
    locations: PropTypes.any.isRequired,
    hasCover: PropTypes.bool.isRequired,
  }

  static defaultProps = {
    defaultValue: [],
  }

  constructor(props) {
    super(props)

    this.images = props.value || props.defaultValue || []
  }

  setCover(images) {
    let firstImage = true
    return images.map((image) => {
      if (!image._destroy && firstImage) { // eslint-disable-line no-underscore-dangle
        firstImage = false
        return { ...image, isCover: true }
      }
      return { ...image, isCover: false }
    })
  }

  handleChange = (images) => {
    images.forEach((newImage) => {
      const index = findIndex(this.images, (image) => newImage.uuid === image.uuid)
      const extractedImage = extractImageAttr(newImage)
      if (~index) {
        this.images = this.images.map((image, iindex) => {
          if (index === iindex) {
            return { ...image, ...extractedImage }
          }
          return image
        })
      } else {
        this.images = [...this.images, extractedImage]
      }
    })
    if (this.props.hasCover) {
      this.images = this.setCover(this.images)
    }
    this.images.forEach((image, index) => (image.sort = index))
    this.props.onChange(this.images)
  }

  handleLocationChange = index => location => {
    this.images = this.images.map((image, iindex) => {
      if (index === iindex) {
        return { ...image, location }
      }
      return image
    })
    this.props.onChange(this.images)
  }

  handleMove = (dragIndex, hoverIndex) => {
    const image = this.images[dragIndex]

    this.images = update(this.images, {
      $splice: [
        [dragIndex, 1],
        [hoverIndex, 0, image],
      ],
    })

    if (this.props.hasCover) {
      this.images = this.setCover(this.images)
    }
    this.images.forEach((image, index) => (image.sort = index))
    this.props.onChange(this.images)
  }

  handleDestroy = index => () => {
    this.images = this.images.map((image, iindex) => {
      if (index === iindex) {
        return { ...image, _destroy: true }
      }
      return image
    })

    if (this.props.hasCover) {
      this.images = this.setCover(this.images)
    }
    this.props.onChange(this.images)
  }

  render() {
    const { oss, value, defaultValue, locations } = this.props

    const images = value || defaultValue

    let count = 0

    return (
      <Row type="flex">
        <Col span="8">
          <UploadButton oss={oss} fileList={images} handleChange={this.handleChange} />
        </Col>
        {images.map((image, index) => {
          if (image._destroy) { return null } // eslint-disable-line no-underscore-dangle

          count += 1

          return (
            <Image
              key={image.id || image.uuid}
              index={index}
              image={image}
              locations={locations}
              handleLocationChange={this.handleLocationChange(index)}
              handleDestroy={this.handleDestroy(index)}
              handleMove={this.handleMove}
            />
          )
        })}
        {count >= 9 &&
          <Col span="8">
            <UploadButton oss={oss} fileList={images} handleChange={this.handleChange} />
          </Col>
        }
      </Row>
    )
  }
}
