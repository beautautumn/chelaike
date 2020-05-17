import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { price } from 'helpers/car'
import { Segment } from 'components'
import { Element } from 'react-scroll'

export default class Cost extends PureComponent {
  static propTypes = {
    currentUser: PropTypes.object.isRequired,
    car: PropTypes.object.isRequired
  }

  render() {
    const { car } = this.props

    const { costStatement } = car
    const costRows = []
    if (costStatement) {
      Object.keys(costStatement).forEach(key => {
        let row = []
        if (costRows.length > 0 && costRows[costRows.length - 1].length < 4) {
          row = costRows[costRows.length - 1]
        } else {
          costRows.push(row)
        }
        row.push(
          <td className="two wide header" key={`${key}-key`}>{costStatement[key].name}</td>
        )
        row.push(
          <td className="six wide" key={`${key}-value`}>
            {price(costStatement[key].value, costStatement[key].unit)}
          </td>
        )
      })
      if (costRows.length > 0 && costRows[costRows.length - 1].length < 4) {
        costRows[costRows.length - 1].push(<td className="two wide header" key="empty-key"></td>)
        costRows[costRows.length - 1].push(<td className="six wide" key="empty-value"></td>)
      }
    }

    return (
      <Element name="cost">
        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <h3 className="ui dividing header">成本信息</h3>
            <table className="ui left aligned celled table">
              <tbody>
                <tr>
                  <td className="two wide header">总成本</td>
                  <td colSpan="3">
                    {car.costSum && price(car.costSum.value, '万')}
                  </td>
                </tr>
                {costRows.map((row, index) => (
                  <tr key={index}>{row}</tr>
                ))}
              </tbody>
            </table>
          </div>
        </Segment>
      </Element>
    )
  }
}
