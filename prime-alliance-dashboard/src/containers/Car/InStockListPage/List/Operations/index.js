import React, { PropTypes } from 'react'
import { Menu, Dropdown, Icon } from 'antd'
import can from 'helpers/can'
import config from 'config'
import { Link } from 'react-router'

/*eslint-disable*/
function imageDownloadLink(car, user, imageType) {
  return `${config.serverUrl + config.basePath}/cars/${car.id}/images_download?download_type=car&image_type=${imageType}&AutobotsToken=${user.token}`
}
/*eslint-enable*/

export default function Operations({ currentUser, car, handleImageUpload }) {
  const menus = []

  if (can('车辆信息编辑', null, car.shopId)) {
    menus.push(
      <Menu.Item key="edit">
        <Link to={`/cars/${car.id}/edit`}>编辑车辆</Link>
      </Menu.Item>
    )
  }

  if (can('车辆信息编辑', null, car.shopId)) {
    menus.push(
      <Menu.Item key="images">
        <a href="#" onClick={handleImageUpload(car.id)}>联盟图片</a>
      </Menu.Item>
    )
  }

  menus.push(
    <Menu.SubMenu key="imageDownload" title="图片下载">
      <Menu.Item>
        <a href={imageDownloadLink(car, currentUser, 'alliance')}>联盟原图</a>
      </Menu.Item>
      <Menu.Item>
        <a href={imageDownloadLink(car, currentUser, 'alliance_watermark')}>联盟水印图</a>
      </Menu.Item>
      <Menu.Item>
        <a href={imageDownloadLink(car, currentUser, 'original')}>车商原图</a>
      </Menu.Item>
      <Menu.Item>
        <a href={imageDownloadLink(car, currentUser, 'water_mark')}>车商水印图</a>
      </Menu.Item>
    </Menu.SubMenu>
  )

  const menu = <Menu>{menus}</Menu>

  return (
    <Dropdown overlay={menu} trigger={['click']}>
      <a className="ant-dropdown-link" href="#" onClick={event => event.preventDefault()}>
        操作 <Icon type="down" />
      </a>
    </Dropdown>
  )
}

Operations.propTypes = {
  car: PropTypes.object.isRequired,
  currentUser: PropTypes.object.isRequired,
  handleImageUpload: PropTypes.func.isRequired,
}
