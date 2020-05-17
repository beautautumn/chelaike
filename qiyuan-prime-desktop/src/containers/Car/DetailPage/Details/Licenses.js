import React from 'react'
import { Segment, Gallery } from 'components'
import { transferRecordEstimatedTime, licensePresentText } from 'helpers/car'
import date from 'helpers/date'
import { Element } from 'react-scroll'
import can from 'helpers/can'

export default ({ car, enumValues, transfersById }) => {
  if (!transfersById) {
    return (
      <Element name="licenses">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h3 className="ui dividing header">牌证信息</h3>
          </div>
        </Segment>
      </Element>
    )
  }
  const acquisitionTransfer = transfersById[car.acquisitionTransfer]
  const saleTransfer = transfersById[car.saleTransfer] || {}

  return (
    <Element name="licenses">
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3 className="ui dividing header">牌证信息</h3>
          <div className="ui grid">
            <div className="eight wide column">
              {can('牌证信息查看') &&
                <table className="ui left aligned celled table">
                  <caption className="ui header">收购过户信息</caption>
                  <tbody>
                    <tr>
                      <td className="four wide header">手续状态</td>
                      <td>{enumValues.transfer_record.state[acquisitionTransfer.state]}</td>
                      <td className="four wide header">预计完成时间</td>
                      <td>{date(transferRecordEstimatedTime(acquisitionTransfer))}</td>
                    </tr>
                    <tr>
                      <td className="header">手续联系电话</td>
                      <td>{acquisitionTransfer.contactPerson}</td>
                      <td className="header">手续联系人</td>
                      <td>{acquisitionTransfer.contactMobile}</td>
                    </tr>
                    <tr>
                      <td className="header">车牌原属地</td>
                      <td>
                        {acquisitionTransfer.originalLocationProvince}
                        {acquisitionTransfer.originalLocationCity}
                      </td>
                      <td className="header">原车主联系电话</td>
                      <td>{acquisitionTransfer.originalOwnerContactMobile}</td>
                    </tr>
                    <tr>
                      <td className="header">原车牌号</td>
                      <td>{acquisitionTransfer.originalPlateNumber}</td>
                      <td className="header">现车牌号</td>
                      <td>{acquisitionTransfer.currentPlateNumber}</td>
                    </tr>
                    <tr>
                      <td className="header">原车主姓名</td>
                      <td>{acquisitionTransfer.originalOwner}</td>
                      <td className="header">原车身份证</td>
                      <td>{acquisitionTransfer.originalOwnerIdcard}</td>
                    </tr>
                    <tr>
                      <td className="header">落户人</td>
                      <td>{acquisitionTransfer.transferRecevier}</td>
                      <td className="header">落户完成时间</td>
                      <td>{date(acquisitionTransfer.transferFinishTime)}</td>
                    </tr>
                    <tr>
                      <td className="four wide header">落户费用</td>
                      <td colSpan="3">{acquisitionTransfer.totalTransferFeeYuan}</td>
                    </tr>
                    <tr>
                      <td className="header">登记证书号</td>
                      <td colSpan="3">{acquisitionTransfer.registrationNumber}</td>
                    </tr>
                    <tr>
                      <td className="header">发动机号</td>
                      <td>{acquisitionTransfer.engineNumber}</td>
                      <td className="header">核载人数</td>
                      <td>{acquisitionTransfer.allowedPassengersCount}</td>
                    </tr>
                    <tr>
                      <td className="header">钥匙数</td>
                      <td>{acquisitionTransfer.keyCount}</td>
                      <td className="header">过户次数</td>
                      <td>{acquisitionTransfer.transferCount}</td>
                    </tr>
                    <tr>
                      <td className="four wide header">使用性质</td>
                      {/*eslint-disable*/}
                      <td>{enumValues.transfer_record.usage_type[acquisitionTransfer.usageType]}</td>
                      <td className="four wide header">验车状态</td>
                      <td>{enumValues.transfer_record.inspection_state[acquisitionTransfer.inspectionState]}</td>
                      {/*eslint-enable*/}
                    </tr>
                    <tr>
                      <td className="header">收购过户描述</td>
                      <td colSpan="3">{acquisitionTransfer.note}</td>
                    </tr>
                  </tbody>
                </table>
              }
            </div>

            <div className="eight wide column">
              {can('牌证信息查看') &&
                <table className="ui left aligned celled table">
                  <caption className="ui header">销售过户信息</caption>
                  <tbody>
                    <tr>
                      <td className="four wide header">手续状态</td>
                      <td>{enumValues.transfer_record.state[saleTransfer.state]}</td>
                      <td className="four wide header">预计完成时间</td>
                      <td>{date(transferRecordEstimatedTime(saleTransfer))}</td>
                    </tr>
                    <tr>
                      <td className="header">手续联系电话</td>
                      <td>{saleTransfer.contactPerson}</td>
                      <td className="header">手续联系人</td>
                      <td>{saleTransfer.contactMobile}</td>
                    </tr>
                    <tr>
                      <td className="header">车牌现属地</td>
                      <td>
                        {saleTransfer.currentLocationProvince}
                        {saleTransfer.currentLocationCity}
                      </td>
                      <td className="header">新车主联系电话</td>
                      <td>{saleTransfer.newOwnerContactMobile}</td>
                    </tr>
                    <tr>
                      <td className="header">现车牌号</td>
                      <td>{saleTransfer.originalPlateNumber}</td>
                      <td className="header">新车牌号</td>
                      <td>{saleTransfer.newPlateNumber}</td>
                    </tr>
                    <tr>
                      <td className="header">新车主姓名</td>
                      <td>{saleTransfer.newOwner}</td>
                      <td className="header">新车身份证</td>
                      <td>{saleTransfer.newOwnerIdcard}</td>
                    </tr>
                    <tr>
                      <td className="header">销售员</td>
                      <td>{saleTransfer.userName}</td>
                      <td className="header">落户完成时间</td>
                      <td>{date(saleTransfer.transferFinishTime)}</td>
                    </tr>
                    <tr>
                      <td className="four wide header">落户费用</td>
                      <td colSpan="3">{saleTransfer.totalTransferFeeYuan}</td>
                    </tr>
                    <tr>
                      <td className="header">销售过户描述</td>
                      <td colSpan="3">{saleTransfer.note}</td>
                    </tr>
                  </tbody>
                </table>
              }
            </div>
          </div>

          <div className="ui grid">
            <div className="eight wide column">
              {(can('牌证图片查看') || can('牌证信息查看')) &&
                <Gallery images={acquisitionTransfer.images} defaultImage="licence" />
              }
            </div>
            <div className="eight wide column">
              {(can('牌证图片查看') || can('牌证信息查看')) &&
                <table className="ui left aligned celled table">
                  <tbody>
                    <tr>
                      <td className="four wide header">行驶证</td>
                      <td>{licensePresentText(acquisitionTransfer, 'driving_license')}</td>
                    </tr>
                    <tr>
                      <td className="header">登记证</td>
                      <td>{licensePresentText(acquisitionTransfer, 'registration_license')}</td>
                    </tr>
                    <tr>
                      <td className="header">车辆牌照</td>
                      <td>{licensePresentText(acquisitionTransfer, 'original_license')}</td>
                    </tr>
                    <tr>
                      <td className="header">环保标记</td>
                      <td>{licensePresentText(acquisitionTransfer, 'environment_mark')}</td>
                    </tr>
                    <tr>
                      <td className="header">原车发票</td>
                      <td>{licensePresentText(acquisitionTransfer, 'original_vehicle_invoice')}</td>
                    </tr>
                    <tr>
                      <td className="header">购置税</td>
                      <td>{licensePresentText(acquisitionTransfer, 'purchase_tax')}</td>
                    </tr>
                  </tbody>
                </table>
              }
            </div>
          </div>
        </div>
      </Segment>
    </Element>
  )
}
