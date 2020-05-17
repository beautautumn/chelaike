import React from 'react'
import get from 'lodash/get'
import date from 'helpers/date'
import { price } from 'helpers/car'
import compact from 'lodash/compact'
import uniq from 'lodash/uniq'
import { Row, Col } from 'antd'

export default ({ intention, channelsById, intentionLevelsById, usersById }) => {
  const intentionLevel = get(intentionLevelsById, intention.intentionLevel)
  const assignee = get(usersById, intention.assignee)
  const location = uniq([intention.province, intention.city]).join('')

  const renderBudget = () => (
    compact([
      intention.minimumPriceWan,
      intention.maximumPriceWan
    ]).join('-') + '万'
  )

  const renderSaleIntention = () => {
    const channel = get(channelsById, intention.channel)
    return (
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
          <div>
            评估价格：{price(intention.estimatedPriceWan, '万')}
          </div>
          <div>
            客户来源：{channel && channel.name}
          </div>
        </div>
      </Col>
    )
  }

  const renderSeekIntention = () => {
    const channel = get(channelsById, intention.channel)
    let car
    if (!intention.sourceCar) {
      car = intention.seekingCars.filter((car) => car.brandName || car.seriesName).map((car) => (
        [car.brandName, car.seriesName].join(' ')
      )).join('，')
    } else {
      const wdUrl = `http://wd.chelaike.com/#!/${intention.sourceCompany.id}/product/${intention.sourceCar.id}/`
      car = (
        <span>
          <a href={wdUrl} target="_blank">{intention.sourceCar.name}</a>
          ({intention.sourceCompany.name})
        </span>
      )
    }

    return (
      <Col span="12">
        <div>
          <div>
            电话：{intention.customerPhone}
          </div>
          <div>
            求购：{car}
          </div>
          <div>
            预算：{renderBudget()}
          </div>
          <div>
            客户来源：{channel && channel.name}
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
            客户级别：{intentionLevel && intentionLevel.name}
          </div>
          <div>
            负责人：{assignee && assignee.name}
          </div>
          <div>
            归属地区：{location}
          </div>
          <div>
            创建时间：{date(intention.createdAt)}
          </div>
          {intention.state === 'processing' &&
            <div>
              跟进日期：{date(intention.processingTime)}
            </div>
          }
          {intention.state === 'interviewed' &&
            <div>
              预约时间：{date(intention.interviewedTime, 'MM-DD HH:mm')}
            </div>
          }
        </div>
      </Col>
    </Row>
  )
}
