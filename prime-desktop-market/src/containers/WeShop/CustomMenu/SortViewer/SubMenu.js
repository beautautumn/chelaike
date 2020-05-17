import React, { Component, PropTypes } from 'react'
import { findDOMNode } from 'react-dom'
import { DragSource, DropTarget } from 'react-dnd'
import styles from '../CustomMenu.scss'
import cx from 'classnames'

const subMenuSource = {
  beginDrag(props) {
    return {
      index: props.index
    }
  }
}

const subMenuTarget = {
  hover(props, monitor, component) {
    const dragIndex = monitor.getItem().index
    const hoverIndex = props.index
    const groupIndex = props.groupIndex

    // Don't replace items with themselves
    if (dragIndex === hoverIndex) {
      return
    }

    // Determine rectangle on screen
    const hoverBoundingRect = findDOMNode(component).getBoundingClientRect()

    // Get vertical middle
    const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2

    // Determine mouse position
    const clientOffset = monitor.getClientOffset()

    // Get pixels to the top
    const hoverClientY = clientOffset.y - hoverBoundingRect.top

    // Only perform the move when the mouse has crossed half of the items height
    // When dragging downwards, only move when the cursor is below 50%
    // When dragging upwards, only move when the cursor is above 50%

    // Dragging downwards
    if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) {
      return
    }

    // Dragging upwards
    if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) {
      return
    }

    // Time to actually perform the action
    props.moveSubMenu(groupIndex, dragIndex, hoverIndex)

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    monitor.getItem().index = hoverIndex
  }
}

@DropTarget('subMenu', subMenuTarget, connect => ({             // eslint-disable-line
  connectDropTarget: connect.dropTarget()
}))
@DragSource('subMenu', subMenuSource, (connect, monitor) => ({  // eslint-disable-line
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging()
}))
export default class subMenu extends Component {
  static propTypes = {
    connectDragSource: PropTypes.func.isRequired,
    connectDropTarget: PropTypes.func.isRequired,
    index: PropTypes.number.isRequired,
    isDragging: PropTypes.bool.isRequired,
    menu: PropTypes.object.isRequired,
    moveSubMenu: PropTypes.func.isRequired,
  }

  render() {
    const {
      menu,
      isDragging,
      connectDragSource,
      connectDropTarget,
    } = this.props
    const opacity = isDragging ? 0 : 1

    return connectDragSource(connectDropTarget(
      <li className={cx(styles.subItem)} style={{ opacity }}>
        <a>
          <span className={styles.inner}>{menu.name}</span>
        </a>
      </li>
    ))
  }
}
