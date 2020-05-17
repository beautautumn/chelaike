import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchMenus, updateMenu, publishMenu } from 'redux/modules/weShop'
import { connectData } from 'decorators'
import { Segment } from 'components'
import { Alert, Row, Col, Button, Modal } from 'antd'
import styles from '../CustomMenu.scss'
import MenuPreview from '../MenuPreview/MenuPreview'
import SortViewer from '../SortViewer/SortViewer'
import MenuForm from '../MenuForm/MenuForm'
import uniqueId from 'lodash/uniqueId'
import { touch } from 'redux-form'
const confirm = Modal.confirm

function fetchData(getState, dispatch) {
  return dispatch(fetchMenus())
}

@connectData(fetchData)
@connect(
  state => ({
    customMenus: state.weShop.customMenus,
  }),
  dispatch => ({
    ...bindActionCreators({
      updateMenu,
      publishMenu,
      touch,
    }, dispatch)
  })
)
export default class MainPage extends Component {
  static propTypes = {
    updateMenu: PropTypes.func.isRequired,
    touch: PropTypes.func.isRequired,
    customMenus: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)

    const { menus } = this.props.customMenus
    this.state = {
      menus,
      orderMenus: [],
      position: [-1, -1],
      sortViewerOpen: false
    }
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.customMenus !== nextProps.customMenus) {
      const { menus } = nextProps.customMenus
      this.setState({ menus })
    }
  }

  handleOrderChange = (orderMenus) => {
    this.setState({ orderMenus })
  }

  handleMenusChange = (menus) => {
    this.setState({ menus }, () => { this.props.updateMenu(this.state.menus) })
  }

  handleSelectedMenuChange = (position, handle) => {
    this.setState({ position }, () => { if (handle) handle() })
  }

  touchAll = () => {
    this.props.touch('customMenu', 'name', 'message', 'url')
  }

  toggleSortViewer = () => {
    const addOrDeleteIdProperty = (isAdd, menus) => {
      if (menus) {
        return menus.map(menu => {
          const newChildren = menu.children ? menu.children.map(child => {
            const newChild = { ...child }
            if (isAdd) {
              newChild.id = uniqueId()
            } else {
              delete newChild.id
            }
            return newChild
          }) : null

          const newMenu = { ...menu, children: newChildren }
          if (isAdd) {
            newMenu.id = uniqueId()
          } else {
            delete newMenu.id
          }
          return newMenu
        })
      }
      return []
    }
    if (this.state.sortViewerOpen) {
      this.handleMenusChange(addOrDeleteIdProperty(false, this.state.orderMenus))
    } else {
      this.setState({ orderMenus: addOrDeleteIdProperty(true, this.state.menus) })
    }
    this.setState({ sortViewerOpen: !this.state.sortViewerOpen })
  }

  handlePublish = () => {
    const { publishMenu } = this.props
    const { menus } = this.state

    const notValid = (menu) => (
      !menu.name ||
      (menu.cate === 'msg' && !menu.message) ||
      (menu.cate === 'url' && !menu.url)
    )

    if (menus) {
      for (let i = 0; i < menus.length; ++i) {
        const menu = menus[i]
        if (notValid(menu)) {
          this.handleSelectedMenuChange([i, -1], this.touchAll)
          return
        }
        if (menu.children) {
          for (let j = 0; j < menu.children.length; j++) {
            if (notValid(menu.children[j])) {
              this.handleSelectedMenuChange([i, j], this.touchAll)
              return
            }
          }
        }
      }
    }

    confirm({
      title: '发布确认',
      content: '发布成功后会覆盖原版本，且将在24小时内对所有用户生效，确认发布？',
      onOk: publishMenu,
      onCancel() {}
    })
  }

  render() {
    if (this.props.customMenus.serviceTypeInfo !== 'service' ||
        this.props.customMenus.verifyTypeInfo !== true) {
      return (
        <div>
          <Segment className={'ui segment ' + styles.disabled}>
            <h4>自定义菜单</h4>
            <Alert
              message="当前公众号不支持自定义菜单管理"
              description="只有认证的微信服务号才享受价签扫码关注公众号功能，订阅号不建议绑定。"
              type="info"
              showIcon
            />
          </Segment>
        </div>
      )
    }

    const { title, state } = this.props.customMenus
    const { menus, position, sortViewerOpen, orderMenus } = this.state

    return (
      <div>
        <Segment className="ui segment">
          <h4>自定义菜单</h4>
          {state === 'editing' &&
            <Alert
              message="菜单编辑中"
              description="菜单未发布，请确认菜单编辑完成后点击“保存并发布”同步到手机。"
              type="info"
              showIcon
            />
          }
          {state === 'published' &&
            <Alert
              message="菜单已发布"
              description="15小时后可在手机查看菜单内容。"
              type="info"
              showIcon
            />
          }
          <div className={styles.settingArea}>
            {!sortViewerOpen &&
              <MenuPreview
                title={title}
                menus={menus}
                handleMenusChange={this.handleMenusChange}
                handleSelectedMenuChange={this.handleSelectedMenuChange}
                position={position}
              />
            }
            {sortViewerOpen &&
              <SortViewer
                title={title}
                menus={orderMenus}
                handleOrderChange={this.handleOrderChange}
              />
            }
            <MenuForm
              menus={menus}
              handleMenusChange={this.handleMenusChange}
              handleSelectedMenuChange={this.handleSelectedMenuChange}
              position={position}
              sortViewerOpen={sortViewerOpen}
            />
          </div>
          <Row className={styles.buttonBar}>
            <Col offset="3" span="1">
              <Button type="ghost" size="large" onClick={this.toggleSortViewer}>
                {!sortViewerOpen ? '菜单排序' : '完成'}
              </Button>
            </Col>
            <Col offset="8" className={styles.leftPadding}>
              <Button
                type="primary"
                size="large"
                onClick={this.handlePublish}
              >
                发布
              </Button>
            </Col>
          </Row>
        </Segment>
      </div>
    )
  }
}
