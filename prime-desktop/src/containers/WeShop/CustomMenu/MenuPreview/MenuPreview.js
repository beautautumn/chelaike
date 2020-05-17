import React, { Component, PropTypes } from 'react'
import { Icon } from 'antd'
import styles from '../CustomMenu.scss'
import cx from 'classnames'
import update from 'react-addons-update'

export default class MenuPreview extends Component {
  static propTypes = {
    title: PropTypes.string.isRequired,
    menus: PropTypes.array,
    handleMenusChange: PropTypes.func.isRequired,
    handleSelectedMenuChange: PropTypes.func.isRequired,
  }

  appendMenuToRoot = () => {
    const { menus } = this.props
    if (menus.length < 3) {
      const newMenus = update(menus, {
        $push: [{
          name: '菜单名称',
          cate: 'msg',
          url: '',
          message: '',
        }]
      })
      this.props.handleMenusChange(newMenus)
      this.props.handleSelectedMenuChange([newMenus.length - 1, -1])
    }
  }

  appendMenuToSub = (position) => () => {
    if (position < 3) {
      const menus = []
      let subIndex = -1
      this.props.menus.forEach((menu, index) => {
        if (index === position) {
          const children = menu.children ? [...menu.children] : []
          if (children.length < 5) {
            children.push({
              name: '子菜单名称',
              cate: 'msg',
              url: '',
              message: '',
            })
          }
          const newMenu = { ...menu, children, cate: 'group' }
          menus.push(newMenu)
          subIndex = children.length - 1
        } else {
          menus.push(menu)
        }
      })
      this.props.handleMenusChange(menus)
      this.props.handleSelectedMenuChange([position, subIndex])
    }
  }

  renderGroupMenus(menus) {
    let menuItems = []
    if (menus.length === 0) {
      menuItems.push(
        <li key="add" className={cx(styles.item, styles.sizeOf1)}>
          <a className={styles.link} onClick={this.appendMenuToRoot}>
            <Icon type="plus" />
            <span>添加菜单</span>
          </a>
        </li>
      )
    } else {
      const size = menus.length === 1 ? 2 : 3
      const sizeClassName = styles['sizeOf' + size]
      menuItems = menus.map((menu, index) =>
        this.renderGroupMenu(menu, index, sizeClassName)
      )
      if (menus.length < 3) {
        menuItems.push(
          <li key="add" className={cx(styles.item, sizeClassName)}>
            <a className={styles.link} onClick={this.appendMenuToRoot}>
              <Icon type="plus" />
            </a>
          </li>
        )
      }
    }

    return (
      <ul className={styles.bar}>
        {menuItems}
      </ul>
    )
  }

  renderGroupMenu(menu, index, sizeClassName) {
    const { position } = this.props
    const isSelected = position[0] === index && position[1] === -1
    const { handleSelectedMenuChange } = this.props
    return (
      <li
        key={index}
        className={cx(styles.item, sizeClassName, { [styles.current]: isSelected })}
      >
        <a className={styles.link} onClick={() => { handleSelectedMenuChange([index, -1]) }}>
          {menu.cate === 'group' && <Icon type="bars" />}
          <span>{menu.name}</span>
        </a>
        {position[0] === index && this.renderSubMenus(menu.children, index)}
      </li>
    )
  }

  renderSubMenus(menus, rootIndex) {
    const { handleSelectedMenuChange, position } = this.props
    return (
      <div className={styles.subMenuBox}>
        <ul className={styles.subList}>
          {menus && menus.map((cur, index) => {
            const isSelected = position[0] === rootIndex && position[1] === index
            return (
              <li key={index} className={cx(styles.subItem, { [styles.current]: isSelected })}>
                <a onClick={() => { handleSelectedMenuChange([rootIndex, index]) }}>
                  <span className={styles.inner}>{cur.name}</span>
                </a>
              </li>
            )
          })}
          {(!menus || menus.length < 5) &&
            <li key="add" className={styles.subItem}>
              <a onClick={this.appendMenuToSub(rootIndex)}>
                <span className={styles.inner}>
                  <Icon type="plus" />
                </span>
              </a>
            </li>
          }
        </ul>
        <i className={styles.subMenuArrowOut}></i>
        <i className={styles.subMenuArrowIn}></i>
      </div>
    )
  }

  render() {
    const { title, menus } = this.props
    return (
      <div className={styles.preview}>
        <div className={styles.main}>
          <div className={styles.head}>{title}</div>
          <div className={styles.body}>
            {this.renderGroupMenus(menus)}
          </div>
        </div>
      </div>
    )
  }
}
