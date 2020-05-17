import React, { Component, PropTypes } from 'react'
import { Menu, Icon, Affix } from 'antd'
import styles from './EditPage.scss'
import { Link } from 'react-scroll'
import can from 'helpers/can'

const items = [
  { name: 'acquisition', text: '收购信息' },
  { name: 'basic', text: '基本信息' },
  { name: 'price', text: '定价信息', authority: '车辆销售定价' },
  { name: 'description', text: '车辆描述' },
  { name: 'sales', text: '销售描述' },
  { name: 'images', text: '图片管理' },
  { name: 'maintaining', text: '车辆保养' },
  { name: 'features', text: '车辆配置' },
  // { name: 'publisher', text: '一键发车' },
  // { name: 'license', text: '牌证管理' },
  // { name: 'preparation', text: '整备管理' },
  // { name: 'status', text: '修改状态' }
]

function ItemLink({ item, status }) {
  const dirty = status[item.name] && status[item.name].dirty
  const invalid = status[item.name] && status[item.name].invalid

  return (
    <Link
      to={item.name}
      smooth
      offset={-30}
      duration={500}
      className={styles.navItem}
    >
      {item.text + ' '}
      {dirty && <Icon type="edit" />}
      {invalid && <Icon type="exclamation-circle-o" />}
    </Link>
  )
}

/*
function tabIsDisabled(isNewCar, carState, itemName) {
  if (['driven_back', 'sold', 'acquisition_refunded'].includes(carState) &&
      itemName !== 'basic') {
    return true
  }
  return isNewCar && itemName !== 'acquisition'
}
*/

export default class Navbar extends Component {
  static propTypes = {
    subformStatus: PropTypes.object.isRequired,
    tab: PropTypes.string,
    useableTabs: PropTypes.array,
    shopId: PropTypes.number.isRequired,
  }

  isUseable(tab) {
    return !this.props.useableTabs || this.props.useableTabs.includes(tab)
  }

  render() {
    const { subformStatus, tab, shopId } = this.props
    const selectedItem = tab || 'acquisition'
    return (
      <div className={styles.sider}>
        <Affix >
          <Menu mode="inline" selectedKeys={[selectedItem]}>
          {items.reduce((acc, item) => {
            if (this.isUseable(item.name) &&
                (!item.authority || can(item.authority, null, shopId))) {
              acc.push((
                <Menu.Item key={item.name}>
                  <ItemLink
                    item={item}
                    status={subformStatus}
                  />
                </Menu.Item>
              ))
            }
            return acc
          }, [])}
          </Menu>
        </Affix>
      </div>
    )
  }
}
