import React, { PropTypes } from 'react'
import { Row, Col } from 'antd'
import { Gallery, Segment } from 'components'
import { transferRecordEstimatedTime, licensePresentText } from 'helpers/car'
import date from 'helpers/date'
import { Element } from 'react-scroll'
import styles from '../../style.scss'

export default function Licenses({ car, enumValues }) {
  const acquisitionTransfer = car.acquisitionTransfer || {}
  const saleTransfer = car.saleTransfer || {}

  return (
    <Element name="licenses">
      <Segment>
        <h3>牌证信息</h3>
        <Row>
          <Col span="11">
            <table className={styles.table}>
              <caption>收购过户信息</caption>
              <tbody>
                <tr>
                  <td className={styles.header}>手续状态</td>
                  <td>{enumValues.transfer_record.state[acquisitionTransfer.state]}</td>
                  <td className={styles.header}>预计完成时间</td>
                  <td>{date(transferRecordEstimatedTime(acquisitionTransfer))}</td>
                </tr>
                <tr>
                  <td className={styles.header}>手续联系电话</td>
                  <td>{acquisitionTransfer.contactPerson}</td>
                  <td className={styles.header}>手续联系人</td>
                  <td>{acquisitionTransfer.contactMobile}</td>
                </tr>
                <tr>
                  <td className={styles.header}>车牌原属地</td>
                  <td>
                    {acquisitionTransfer.originalLocationProvince}
                    {acquisitionTransfer.originalLocationCity}
                  </td>
                  <td className={styles.header}>原车主联系电话</td>
                  <td>{acquisitionTransfer.originalOwnerContactMobile}</td>
                </tr>
                <tr>
                  <td className={styles.header}>原车牌号</td>
                  <td>{acquisitionTransfer.originalPlateNumber}</td>
                  <td className={styles.header}>现车牌号</td>
                  <td>{acquisitionTransfer.currentPlateNumber}</td>
                </tr>
                <tr>
                  <td className={styles.header}>原车主姓名</td>
                  <td>{acquisitionTransfer.originalOwner}</td>
                  <td className={styles.header}>原车身份证</td>
                  <td>{acquisitionTransfer.originalOwnerIdcard}</td>
                </tr>
                <tr>
                  <td className={styles.header}>落户人</td>
                  <td>{acquisitionTransfer.transferRecevier}</td>
                  <td className={styles.header}>落户完成时间</td>
                  <td>{date(acquisitionTransfer.transferFinishTime)}</td>
                </tr>
                <tr>
                  <td className={styles.header}>落户费用</td>
                  <td colSpan="3">{acquisitionTransfer.totalTransferFeeYuan}</td>
                </tr>
                <tr>
                  <td className={styles.header}>登记证书号</td>
                  <td colSpan="3">{acquisitionTransfer.registrationNumber}</td>
                </tr>
                <tr>
                  <td className={styles.header}>发动机号</td>
                  <td>{acquisitionTransfer.engineNumber}</td>
                  <td className={styles.header}>核载人数</td>
                  <td>{acquisitionTransfer.allowedPassengersCount}</td>
                </tr>
                <tr>
                  <td className={styles.header}>钥匙数</td>
                  <td>{acquisitionTransfer.keyCount}</td>
                  <td className={styles.header}>过户次数</td>
                  <td>{acquisitionTransfer.transferCount}</td>
                </tr>
                <tr>
                  <td className={styles.header}>使用性质</td>
                  <td>{enumValues.transfer_record.usage_type[acquisitionTransfer.usageType]}</td>
                  <td className={styles.header}>验车状态</td>
                  {/*eslint-disable*/}
                  <td>{enumValues.transfer_record.inspection_state[acquisitionTransfer.inspectionState]}</td>
                  {/*eslint-enable*/}
                </tr>
                <tr>
                  <td className={styles.header}>收购过户描述</td>
                  <td colSpan="3">{acquisitionTransfer.note}</td>
                </tr>
              </tbody>
            </table>
          </Col>

          <Col span="11" offset="1">
            <table className={styles.table}>
              <caption>销售过户信息</caption>
              <tbody>
                <tr>
                  <td className={styles.header}>手续状态</td>
                  <td>{enumValues.transfer_record.state[saleTransfer.state]}</td>
                  <td className={styles.header}>预计完成时间</td>
                  <td>{date(transferRecordEstimatedTime(saleTransfer))}</td>
                </tr>
                <tr>
                  <td className={styles.header}>手续联系电话</td>
                  <td>{saleTransfer.contactPerson}</td>
                  <td className={styles.header}>手续联系人</td>
                  <td>{saleTransfer.contactMobile}</td>
                </tr>
                <tr>
                  <td className={styles.header}>车牌现属地</td>
                  <td>
                    {saleTransfer.currentLocationProvince}
                    {saleTransfer.currentLocationCity}
                  </td>
                  <td className={styles.header}>新车主联系电话</td>
                  <td>{saleTransfer.newOwnerContactMobile}</td>
                </tr>
                <tr>
                  <td className={styles.header}>现车牌号</td>
                  <td>{saleTransfer.originalPlateNumber}</td>
                  <td className={styles.header}>新车牌号</td>
                  <td>{saleTransfer.newPlateNumber}</td>
                </tr>
                <tr>
                  <td className={styles.header}>新车主姓名</td>
                  <td>{saleTransfer.newOwner}</td>
                  <td className={styles.header}>新车身份证</td>
                  <td>{saleTransfer.newOwnerIdcard}</td>
                </tr>
                <tr>
                  <td className={styles.header}>销售员</td>
                  <td>{saleTransfer.userName}</td>
                  <td className={styles.header}>落户完成时间</td>
                  <td>{date(saleTransfer.transferFinishTime)}</td>
                </tr>
                <tr>
                  <td className={styles.header}>落户费用</td>
                  <td colSpan="3">{saleTransfer.totalTransferFeeYuan}</td>
                </tr>
                <tr>
                  <td className={styles.header}>销售过户描述</td>
                  <td colSpan="3">{saleTransfer.note}</td>
                </tr>
              </tbody>
            </table>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <Gallery images={acquisitionTransfer.images} defaultImage="licence" />
          </Col>
          <Col span="11" offset="1">
            <table className={styles.table}>
              <tbody>
                <tr>
                  <td className={styles.header}>行驶证</td>
                  <td>{licensePresentText(acquisitionTransfer, 'driving_license')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>登记证</td>
                  <td>{licensePresentText(acquisitionTransfer, 'registration_license')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>车辆牌照</td>
                  <td>{licensePresentText(acquisitionTransfer, 'original_license')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>环保标记</td>
                  <td>{licensePresentText(acquisitionTransfer, 'environment_mark')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>原车发票</td>
                  <td>{licensePresentText(acquisitionTransfer, 'original_vehicle_invoice')}</td>
                </tr>
                <tr>
                  <td className={styles.header}>购置税</td>
                  <td>{licensePresentText(acquisitionTransfer, 'purchase_tax')}</td>
                </tr>
              </tbody>
            </table>
          </Col>
        </Row>
      </Segment>
    </Element>
  )
}

Licenses.propTypes = {
  car: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}
