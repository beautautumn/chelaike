import React, { Component, PropTypes } from 'react'
import styles from '../CustomMenu.scss'
import SubMenu from './SubMenu'

export default class SubMenuList extends Component {
  static propTypes = {
    menus: PropTypes.array,
    moveSubMenu: PropTypes.func.isRequired,
    groupIndex: PropTypes.number.isRequired,
  }

  render() {
    const { menus, groupIndex, moveSubMenu } = this.props

    if (!menus || menus.length === 0) return null

    return (
      <div className={styles.subMenuBox}>
        <ul className={styles.subList}>
          {menus.map((cur, index) => (
            <SubMenu
              key={cur.id}
              menu={cur}
              index={index}
              groupIndex={groupIndex}
              moveSubMenu={moveSubMenu}
            />
          ))}
        </ul>
        <i className={styles.subMenuArrowOut}></i>
        <i className={styles.subMenuArrowIn}></i>
      </div>
    )
  }
}
