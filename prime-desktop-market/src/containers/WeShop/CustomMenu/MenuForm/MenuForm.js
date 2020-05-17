import React, { Component, PropTypes } from 'react'
import styles from '../CustomMenu.scss'
import update from 'react-addons-update'
import Form from './Form'
import { Modal } from 'antd'
const confirm = Modal.confirm

export default class MenuForm extends Component {
  static propTypes = {
    menus: PropTypes.array,
    position: PropTypes.array.isRequired,
    handleMenusChange: PropTypes.func.isRequired,
    handleSelectedMenuChange: PropTypes.func.isRequired,
    sortViewerOpen: PropTypes.bool.isRequired,
  }

  handleMenuDelete = () => {
    const { menus, position, handleMenusChange, handleSelectedMenuChange } = this.props
    confirm({
      title: '删除确认',
      content: '删除后菜单下设置的内容将被删除',
      onOk() {
        if (position[0] !== -1) {
          let newMenus
          if (position[1] === -1) {
            newMenus = update(menus, { $splice: [[position[0], 1]] })
          } else {
            newMenus = update(menus, {
              [position[0]]: {
                children: {
                  $splice: [[position[1], 1]]
                }
              }
            })
          }
          handleMenusChange(newMenus)
          handleSelectedMenuChange([-1, -1])
        }
      },
      onCancel() {}
    })
  }

  changeMenuItem = (name, value) => {
    const { menus, position } = this.props
    let newMenus = menus
    if (position[1] === -1) {
      newMenus = update(menus, {
        [position[0]]: {
          [name]: {
            $set: value
          }
        }
      })
    } else {
      newMenus = update(menus, {
        [position[0]]: {
          children: {
            [position[1]]: {
              [name]: {
                $set: value
              }
            }
          }
        }
      })
    }
    this.props.handleMenusChange(newMenus)
  }

  handleInputBlur = (event) => {
    const { name, value } = event.target
    this.changeMenuItem(name, value)
  }

  handleRadioChange = (event) => {
    const { value } = event.target
    this.changeMenuItem('cate', value)
  }

  render() {
    const { menus, position, sortViewerOpen } = this.props
    let initialValues
    if (position[0] !== -1) {
      if (position[1] === -1) {
        initialValues = menus[position[0]]
      } else {
        initialValues = menus[position[0]].children[position[1]]
      }
    }
    return (
      <div className={styles.form}>
        {sortViewerOpen &&
          <div className={styles.tips}>请通过拖拽左边的菜单进行排序</div>
        }
        {!sortViewerOpen && position[0] === -1 &&
          <div className={styles.tips}>点击左侧菜单进行编辑操作</div>
        }
        {!sortViewerOpen && position[0] !== -1 &&
          <div className={styles.main}>
            <div className={styles.editor}>
              <div className={styles.header}>
                <h4>菜单名称</h4>
                <div className={styles.operation}>
                  <a onClick={this.handleMenuDelete}>删除菜单</a>
                </div>
              </div>
              <div className={styles.body}>
                <Form
                  initialValues={initialValues}
                  handleInputBlur={this.handleInputBlur}
                  handleRadioChange={this.handleRadioChange}
                />
              </div>
            </div>
            <div className={styles.arrow}>
              <i className={styles.out}></i>
              <i className={styles.in}></i>
            </div>
          </div>
        }
      </div>
    )
  }
}
