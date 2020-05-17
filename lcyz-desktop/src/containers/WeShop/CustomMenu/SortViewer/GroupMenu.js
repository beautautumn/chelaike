import React, { Component, PropTypes } from 'react'
import { findDOMNode } from 'react-dom'
import { DragSource, DropTarget } from 'react-dnd'
import styles from '../CustomMenu.scss'
import { Icon } from 'antd'
import cx from 'classnames'
import SubMenuList from './SubMenuList'

const groupMenuSource = {
  beginDrag(props) {
    return {
      index: props.index
    }
  }
}

function detectDirection(dragIndex, hoverIndex) {
  // 向右拖1个
  const rightwardsOneTaregt = dragIndex - hoverIndex === -1
  // 向右拖2个
  const rightwardsTwoTaregts = dragIndex - hoverIndex === -2

  if (rightwardsOneTaregt || rightwardsTwoTaregts) {
    return 'right'
  }

  // 向左拖1个
  const leftwardsOneTaregt = dragIndex - hoverIndex === 1
  // 向左拖2个
  const leftwardsTwoTaregts = dragIndex - hoverIndex === 2

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

const groupMenuTarget = {
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
    // const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2
    const hoverMiddleX = (hoverBoundingRect.right - hoverBoundingRect.left) / 2

    // Determine mouse position
    const clientOffset = monitor.getClientOffset()

    // Get pixels to the top
    // const hoverClientY = clientOffset.y - hoverBoundingRect.top // eslint-disable-line
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

    if (direction === 'down') {
      return
    }

    if (direction === 'up') {
      return
    }

    // Time to actually perform the action
    props.moveGroupMenu(dragIndex, hoverIndex)

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    monitor.getItem().index = hoverIndex
  }
}

@DropTarget('groupMenu', groupMenuTarget, connect => ({             // eslint-disable-line
  connectDropTarget: connect.dropTarget()
}))
@DragSource('groupMenu', groupMenuSource, (connect, monitor) => ({  // eslint-disable-line
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging()
}))
export default class GroupMenu extends Component {
  static propTypes = {
    connectDragSource: PropTypes.func.isRequired,
    connectDropTarget: PropTypes.func.isRequired,
    index: PropTypes.number.isRequired,
    isDragging: PropTypes.bool.isRequired,
    menu: PropTypes.object.isRequired,
    moveGroupMenu: PropTypes.func.isRequired,
    moveSubMenu: PropTypes.func.isRequired,
    sizeClassName: PropTypes.string.isRequired,
    handleOpenPositionChange: PropTypes.func.isRequired,
    openPosition: PropTypes.number.isRequired,
  }

  render() {
    const {
      menu,
      isDragging,
      connectDragSource,
      connectDropTarget,
      handleOpenPositionChange,
      sizeClassName,
      openPosition,
      index,
      moveSubMenu,
    } = this.props
    const opacity = isDragging ? 0 : 1

    return connectDragSource(connectDropTarget(
      <li
        className={cx(styles.item, sizeClassName)}
        style={{ opacity }}
      >
        <a className={styles.link} onClick={handleOpenPositionChange}>
          {menu.cate === 'group' && <Icon type="bars" />}
          <span>{menu.name}</span>
        </a>
        {openPosition === index &&
          <SubMenuList menus={menu.children} groupIndex={index} moveSubMenu={moveSubMenu} />
        }
      </li>
    ))
  }
}
