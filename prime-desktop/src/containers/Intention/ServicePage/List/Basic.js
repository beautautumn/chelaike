import React from 'react'
import get from 'lodash/get'
import compact from 'lodash/compact'
import uniq from 'lodash/uniq'
import { Row, Col } from 'antd'

export default ({ intention, channelsById, usersById }) => {
  const assignee = get(usersById, intention.assignee)
  const location = uniq([intention.province, intention.city]).join('')
  const channel = get(channelsById, intention.channel)

  const renderBudget = () => (
    compact([
      intention.minimumPriceWan,
      intention.maximumPriceWan
    ]).join('-') + '万'
  )

  const renderSaleIntention = () => (
    <Col span="12">
      <div>
        <div>
          电话：{intention.customerPhone}
        </div>
        <div>
          出售：{[intention.brandName, intention.seriesName].join(' ')}
        </div>
        <div>
          期望价格：{renderBudget()}
        </div>
      </div>
    </Col>
  )

  const renderSeekIntention = () => {
    const cars = intention.seekingCars
                          .filter((car) => car.brandName || car.seriesName)
                          .map((car) => (
                            [car.brandName, car.seriesName].join(' ')
                          )).join('，')

    return (
      <Col span="12">
        <div>
          <div>
            电话：{intention.customerPhone}
          </div>
          <div>
            求购：{cars}
          </div>
          <div>
            预算：{renderBudget()}
          </div>
        </div>
      </Col>
    )
  }

  return (
    <Row gutter={16}>
      {
        intention.intentionType === 'seek' ?
          renderSeekIntention() : renderSaleIntention()
      }
      <Col span="12">
        <div>
          <div>
            负责人：{assignee && assignee.name}
          </div>
          <div>
            归属地区：{location}
          </div>
          <div>
            客户来源：{channel && channel.name}
          </div>
        </div>
      </Col>
    </Row>
  )
}
