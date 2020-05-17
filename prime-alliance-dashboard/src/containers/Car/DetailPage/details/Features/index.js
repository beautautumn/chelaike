import React, { PropTypes } from 'react'
import { Tabs } from 'antd'
import { featureText } from 'helpers/car'
import { Segment } from 'components'
import { Element } from 'react-scroll'

export default function Features({ car }) {
  return (
    <Element name="features">
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3 className="ui dividing header">车辆配置</h3>

          <Segment className="ui grid segment">
            <div className="twelve wide stretched column">
              <Tabs tabPosition="left">
                {car.manufacturerConfiguration.map((group, index) => (
                  <Tabs.TabPane tab={group.name} key={index}>
                    <table className="ui celled table">
                      <tbody>
                        {group.fields.map((field, fieldIndex) => (
                          <tr key={fieldIndex}>
                            <td className="four wide header">{field.name}</td>
                            <td>{featureText(field.value)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </Tabs.TabPane>
                ))}
              </Tabs>
            </div>
          </Segment>

          <Segment className="ui grid segment">
            <div className="sixteen wide column">
              <div className="ui dividing header">配置说明</div>
              <p>
                {car.configurationNote}
              </p>
            </div>
          </Segment>
        </div>
      </Segment>
    </Element>
  )
}

Features.propTypes = {
  car: PropTypes.object.isRequired,
}
