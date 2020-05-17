import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { push } from 'react-router-redux'
import can from 'helpers/can'

const routes = {
  '/cars': '在库车辆查询',
  '/stock_out_cars': '已出库车辆查询',
  '/licenses': '牌证信息查看',
  '/prepare_records': '整备信息查看',
  '/company': '公司信息设置',
  '/roles': '角色管理',
  '/users': '员工管理',
  '/setting/shops': '业务设置'
}

@connect(
  null,
  dispatch => ({
    ...bindActionCreators({ push }, dispatch)
  })
)
export default class Home extends PureComponent {
  static propTypes = {
    push: PropTypes.func.isRequired
  }

  componentWillMount() {
    const { push } = this.props
    push(this.getHomePage())
  }

  getHomePage() {
    for (const key of Object.keys(routes)) {
      if (can(routes[key])) {
        return key
      }
    }
  }

  render() {
    return (
      <div></div>
    )
  }
}
