import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { price } from 'helpers/car'
import { unit } from 'helpers/app'
import compact from 'lodash/compact'
import { Segment, Rating } from 'components'
import { Element } from 'react-scroll'
import nl2br from 'react-nl2br'
import can from 'helpers/can'

export default class Sales extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired
  }


  renderCooperrationCompanies() {
    const { car } = this.props
    const companies = car.cooperationCompanyRelationships.map((relationship) => (
      <div key={relationship.id} className="item">
        {relationship.cooperationCompany.name} - {price(relationship.cooperationPriceWan, '万')}
      </div>
    ))

    return can('合作信息查看') ? (
      <tr>
        <td className="header">合作商家</td>
        <td colSpan="3">
          <div className="ui list">
            {companies}
          </div>
        </td>
      </tr>
    ) : null
  }

  render() {
    const { car } = this.props

    return (
      <Element name="sales">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h3 className="ui dividing header">销售信息</h3>
            <table className="ui left aligned celled table">
              <tbody>
                {car.acquisitionType === 'acquisition' &&
                 can('收购信息查看') && can('收购价格查看') && (
                  <tr>
                    <td className="two wide header">收购价格</td>
                    <td colSpan="3">
                      {price(car.acquisitionPriceWan, '万')}
                    </td>
                  </tr>
                )}
                {car.acquisitionType === 'consignment' && (
                  <tr>
                    <td className="header">寄卖价</td>
                    <td colSpan="3">
                      {price(car.consignorPriceWan, '万')}
                    </td>
                  </tr>
                )}
                {car.acquisitionType === 'consignment' && (
                  <tr>
                    <td className="header">寄卖人</td>
                    <td>
                      {car.consignorName}
                    </td>
                    <td className="header">联系电话</td>
                    <td>
                      {car.consignorPhone}
                    </td>
                  </tr>
                )}
                {car.acquisitionType === 'cooperation' && (
                  <tr>
                    <td className="header">合作总价</td>
                    <td colSpan="3">
                      {price(car.acquisitionPriceWan, '万')}
                    </td>
                  </tr>
                )}
                {car.acquisitionType === 'cooperation' && this.renderCooperrationCompanies()}
                <tr>
                  <td className="two wide header">新车导价</td>
                  <td className="six wide">{price(car.newCarGuidePriceWan, '万')}</td>
                  <td className="two wide header">新车优惠/加价</td>
                  <td>
                    {
                      compact([
                        unit(car.newCarDiscount, '%'),
                        price(car.newCarAdditionalPriceWan, '万')
                      ]).join('/')
                    }
                  </td>
                </tr>
                <tr>
                  <td className="header">新车完税价</td>
                  <td colSpan="3">{price(car.newCarFinalPriceWan, '万')}</td>
                </tr>
                <tr>
                  {can('销售底价查看', null, car.shop) &&
                    <td className="header">销售底价</td>
                  }
                  {can('销售底价查看', null, car.shop) &&
                    <td>
                      {price(car.salesMinimunPriceWan, '万')}
                    </td>
                  }
                  {can('经理底价查看', null, car.shop) &&
                    <td className="header">经理底价</td>
                  }
                  {can('经理底价查看', null, car.shop) &&
                    <td>
                      {price(car.managerPriceWan, '万')}
                    </td>
                  }
                </tr>
                <tr>
                  <td className="header">展厅标价</td>
                  <td>{price(car.showPriceWan, '万')}</td>
                  <td className="header">网络标价</td>
                  <td>{price(car.onlinePriceWan, '万')}</td>
                </tr>
                <tr>
                  <td className="header">车辆星级</td>
                  <td colSpan="3">
                    <Rating value={car.starRating} interactive={false} />
                  </td>
                </tr>
                <tr>
                  <td className="header">质保等级</td>
                  <td>{car.warranty && car.warranty.name}</td>
                  <td className="header">质保费用</td>
                  <td>{car.warrantyFeeYuan}</td>
                </tr>
                <tr>
                  <td className="header">按揭说明</td>
                  <td colSpan="3">{nl2br(car.mortgageNote)}</td>
                </tr>
                <tr>
                  <td className="header">卖点描述</td>
                  <td colSpan="3">{nl2br(car.sellingPoint)}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </Segment>
      </Element>
    )
  }
}
