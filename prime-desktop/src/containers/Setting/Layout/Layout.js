import React, { Component, PropTypes } from 'react'
import { Link } from 'react-router'

export default class Layout extends Component {
  static propTypes = {
    children: PropTypes.object,
  }

  render() {
    const { children } = this.props
    const settings = [
      { name: '分店', route: '/setting/shops' },
      { name: '渠道', route: '/setting/channels' },
      { name: '绑定账号', route: '/setting/publishers_profile' },
      { name: '质保等级', route: '/setting/warranties' },
      { name: '客户等级', route: '/setting/intention_levels' },
      { name: '客户回收时间', route: '/setting/intention_recovery_time' },
      { name: '到期时间', route: '/setting/guest_reminder_setting' },
      { name: '保险公司', route: '/setting/insurance_companies' },
      { name: '按揭公司', route: '/setting/mortgage_companies' },
      { name: '合作商家', route: '/setting/cooperation_companies' },
      { name: '系统设置', route: '/setting/system' }
    ]

    return (
      <div>
        <h2 className="ui header"> 业务设置 </h2>

        <div className="ui grid">
          <div className="wide column">
            <div className="ui eleven item menu">
            {
              settings.map((setting) => (
                <Link
                  key={setting.name}
                  className="item"
                  to={setting.route}
                  activeClassName="active"
                >
                  {setting.name}
                </Link>
              ))
            }
            </div>
          </div>
        </div>

        {children}
      </div>
    )
  }
}
