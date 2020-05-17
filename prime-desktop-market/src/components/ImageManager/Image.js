import React, { PropTypes } from 'react'
import { findDOMNode } from 'react-dom'
import { PureComponent } from 'react-pure-render'
import { Button, Select, Badge } from 'antd'
import { DragSource, DropTarget } from 'react-dnd'
import { scale } from 'helpers/image'
import cx from 'classnames'
import styles from './ImageManager.scss'

const { Option } = Select

const cardSource = {
  beginDrag(props) {
    return {
      index: props.index
    }
  }
}

function detectDirection(dragIndex, hoverIndex) {
  // 向右拖1个
  const rightwardsOneTaregt = dragIndex - hoverIndex === -1 && (dragIndex - 1) % 3 !== 0
  // 向右拖2个
  const rightwardsTwoTaregts = dragIndex - hoverIndex === -2 && (dragIndex + 1) % 3 === 0

  if (rightwardsOneTaregt || rightwardsTwoTaregts) {
    return 'right'
  }

  // 向左拖1个
  const leftwardsOneTaregt = dragIndex - hoverIndex === 1 && (dragIndex + 1) % 3 !== 0
  // 向左拖2个
  const leftwardsTwoTaregts = dragIndex - hoverIndex === 2 && (dragIndex - 1) % 3 === 0

  if (leftwardsOneTaregt || leftwardsTwoTaregts) {
    return 'left'
  }

  if (dragIndex < hoverIndex) {
    return 'down'
  }

  if (dragIndex > hoverIndex) {
    return 'up'
  }
}

const cardTarget = {
  hover(props, monitor, component) {
    const dragIndex = monitor.getItem().index
    const hoverIndex = props.index

    // Don't replace items with themselves
    if (dragIndex === hoverIndex) {
      return
    }

    // Determine rectangle on screen
    const hoverBoundingRect = findDOMNode(component).getBoundingClientRect()

    // Get vertical middle
    const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2
    const hoverMiddleX = (hoverBoundingRect.right - hoverBoundingRect.left) / 2

    // Determine mouse position
    const clientOffset = monitor.getClientOffset()

    // Get pixels to the top
    const hoverClientY = clientOffset.y - hoverBoundingRect.top // eslint-disable-line
    const hoverClientX = clientOffset.x - hoverBoundingRect.left // eslint-disable-line

    // Only perform the move when the mouse has crossed half of the items height
    // When dragging downwards, only move when the cursor is below 50%
    // When dragging upwards, only move when the cursor is above 50%

    const direction = detectDirection(dragIndex, hoverIndex)

    if (direction === 'right' && hoverClientX < hoverMiddleX) {
      return
    }

    if (direction === 'left' && hoverClientX > hoverMiddleX) {
      return
    }

    if (direction === 'down' && hoverClientY < hoverMiddleY) {
      return
    }

    if (direction === 'up' && hoverClientY > hoverMiddleY) {
      return
    }

    // Time to actually perform the action
    props.handleMove(dragIndex, hoverIndex)

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    monitor.getItem().index = hoverIndex
  }
}

@DropTarget('image', cardTarget, connect => ({ // eslint-disable-line
  connectDropTarget: connect.dropTarget()
}))
@DragSource('image', cardSource, (connect, monitor) => ({ // eslint-disable-line
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging()
}))
export default class Image extends PureComponent {
  static propTypes = {
    image: PropTypes.object.isRequired,
    handleDestroy: PropTypes.func.isRequired,
    handleLocationChange: PropTypes.func.isRequired,
    connectDragSource: PropTypes.func.isRequired,
    connectDropTarget: PropTypes.func.isRequired,
    isDragging: PropTypes.bool.isRequired
  }

  renderMask() {
    const { image } = this.props
    if (image.uploading) {
      return (
        <div className={styles.mask}>
          上传中...
        </div>
      )
    }
  }

  render() {
    const {
      image,
      locations,
      handleLocationChange,
      handleDestroy,
      isDragging,
      connectDragSource,
      connectDropTarget
    } = this.props

    const opacity = isDragging ? 0 : 1

    let imageSrc

    if (image.preview || image.url) {
      imageSrc = image.preview ? image.preview : scale(image.url, '253x150')
    }

    let options
    if (Array.isArray(locations)) {
      options = locations.map((location, index) => (
        <Option key={index} value={location.key}>{location.label}</Option>
      ))
    } else {
      options = Object.keys(locations).map((location, index) => (
        <Option key={index} value={location}>{locations[location]}</Option>
      ))
    }

    return connectDragSource(connectDropTarget(
      <div className={cx('ant-col-8', styles.imageBox)} style={{ opacity }}>
        <Badge count={image.isCover ? '封面' : ''} style={{ backgroundColor: '#87d068' }}>
          <div className={styles.item}>
            <div className="image">
              {this.renderMask()}
              <img role="presentation" src={imageSrc} width="250" height="150" />
            </div>
            <div className={styles.action}>
              <Select
                size="small"
                value={image.location || undefined}
                placeholder="选择位置"
                onChange={handleLocationChange}
              >
                {options}
              </Select>
              <span className={styles.buttons}>
                <Button className={styles.danger} size="small" onClick={handleDestroy}>删除</Button>
              </span>
            </div>
          </div>
        </Badge>
      </div>
    ))
  }
}
