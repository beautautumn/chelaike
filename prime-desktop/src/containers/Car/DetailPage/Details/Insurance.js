import React from 'react'
import { Element } from 'react-scroll'
import { Segment } from 'components'

export default ({ stockOutInventory }) => (
  <Element name="insurance">
    <Segment className="ui grid segment">
      <div className="sixteen wide column">
        <h3 className="ui dividing header">保险信息</h3>
        <table className="ui left aligned celled table">
          {stockOutInventory && stockOutInventory.insuranceCompany && <tbody>
            <tr>
              <td className="two wide header">保险公司</td>
              <td colSpan="3">{stockOutInventory.insuranceCompany.name}</td>
            </tr>
            <tr>
              <td className="two wide header">商业险</td>
              <td className="six wide">
                {stockOutInventory.commercialInsuranceFeeYuan}
              </td>
              <td className="two wide header">交强险</td>
              <td className="six wide">
                {stockOutInventory.compulsoryInsuranceFeeYuan}
              </td>
            </tr>
            <tr>
              <td className="header">备注</td>
              <td colSpan="3">
                {stockOutInventory.note}
              </td>
            </tr>
          </tbody>}
        </table>
      </div>
    </Segment>
  </Element>
)
