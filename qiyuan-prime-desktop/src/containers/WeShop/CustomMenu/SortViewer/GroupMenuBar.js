import React, { Component, PropTypes } from 'react'
import update from 'react-addons-update'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'
import styles from '../CustomMenu.scss'
import GroupMenu from './GroupMenu'

@DragDropContext(HTML5Backend) // eslint-disable-line
export default class GroupMenuBar extends Component {
  static propTypes = {
    menus: PropTypes.array.isRequired,
  }

  constructor(props) {
    super(props)

    const { menus } = props
    this.state = {
      menus,
      openPosition: -1
    }
  }

  moveGroupMenu = (dragIndex, hoverIndex) => {
    const { menus } = this.state
    const dragGroupMenu = menus[dragIndex]

    this.setState(update(this.state, {
      menus: {
        $splice: [
          [dragIndex, 1],
          [hoverIndex, 0, dragGroupMenu]
        ]
      },
      openPosition: {
        $set: hoverIndex
      }
    }), () => {
      this.props.handleOrderChange(this.state.menus)
    })
  }

  moveSubMenu = (groupMenuIndex, dragIndex, hoverIndex) => {
    const { menus } = this.state
    const dragSubMenu = menus[groupMenuIndex].children[dragIndex]

    this.setState(update(this.state, {
      menus: {
        [groupMenuIndex]: {
          children: {
            $splice: [
              [dragIndex, 1],
              [hoverIndex, 0, dragSubMenu]
            ]
          }
        }
      }
    }), () => { this.props.handleOrderChange(this.state.menus) })
  }

  handleOpenPositionChange = (index) => () => {
    this.setState({ openPosition: index })
  }

  render() {
    const { menus, openPosition } = this.state

    let menuItems = []
    if (menus.length > 0) {
      const size = menus.length
      const sizeClassName = styles['sizeOf' + size]
      menuItems = menus.map((menu, index) => (
        <GroupMenu
          key={menu.id}
          index={index}
          sizeClassName={sizeClassName}
          menu={menu}
          moveGroupMenu={this.moveGroupMenu}
          moveSubMenu={this.moveSubMenu}
          handleOpenPositionChange={this.handleOpenPositionChange(index)}
          openPosition={openPosition}
        />
      ))
    }

    return (
      <ul className={styles.bar}>
        {menuItems}
      </ul>
    )
  }
}
