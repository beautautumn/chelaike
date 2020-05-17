import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { Element } from 'react-scroll'
import { unit } from 'helpers/app'
import { Segment } from 'components'

export default class Maitaining extends PureComponent {
  static propTypes = {
    car: PropTypes.object.isRequired
  }

  render() {
    const { car, enumValues } = this.props

    return (
      <Element name="maitaining">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <div className="ui dividing header">保养信息</div>
            <table className="ui left aligned celled table">
              <tbody>
                <tr>
                  <td className="two wide header">保养里程</td>
                  <td>{unit(car.maintainMileage, '万公里')}</td>
                </tr>
                <tr>
                  <td className="two wide header">保养记录</td>
                  <td>{car.hasMaintainHistory ? '有' : '无'}</td>
                </tr>
                <tr>
                  <td className="two wide header">新车质保</td>
                  <td>{enumValues.car.new_car_warranty[car.newCarWarranty]}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </Segment>
      </Element>
    )
  }
}
