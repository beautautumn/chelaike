import React, { PropTypes } from 'react'
import { Menu } from 'antd'
import { Link } from 'react-router'

export default function Layout({ children }) {
  const settings = [
    { name: '渠道', route: '/setting/channels' },
    { name: '客户等级', route: '/setting/intention_levels' },
  ]

  return (
    <div>
      <h2 className="ui header"> 业务设置 </h2>

      <Menu mode="horizontal" style={{ margin: '10px auto 20px auto' }}>
        {
          settings.map((setting) => (
            <Menu.Item key={setting.name}>
              <Link
                key={setting.name}
                to={setting.route}
              >
                {setting.name}
              </Link>
            </Menu.Item>
          ))
        }
      </Menu>

      {children}
    </div>
  )
}

Layout.propTypes = {
  children: PropTypes.element.isRequired,
}
