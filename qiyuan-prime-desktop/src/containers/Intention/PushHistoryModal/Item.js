import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { CarItem } from 'components'
import get from 'lodash/get'
import date from 'helpers/date'

// http://git.che3bao.com/autobots/prime-server/issues/648
const states = {
  pending: '创建',
  completed: '成交',
  failed: '战败',
  interviewed: '预约',
  invalid: '无效',
  processing: '跟进',
  reserved: '预定',
  cancel_reserved: '取消',
  hall_consignment: '厅寄',
  online_consignment: '网寄'
}

export default class Item extends PureComponent {
  static propTypes = {
    usersById: PropTypes.object,
    intentionPushHistory: PropTypes.object.isRequired
  }

  renderCars() {
    const { intentionPushHistory: { cars } } = this.props
    if (cars && cars.length > 0) {
      return cars.map((car) => <CarItem key={car.id} car={car} />)
    }

    const { intentionPushHistory: { closingCar } } = this.props
    if (closingCar) {
      return (<CarItem key={closingCar.id} car={closingCar} />)
    }

    const { intentionPushHistory: { closingCarName } } = this.props
    if (closingCarName) {
      return (<p>成交车辆名称：{closingCarName}</p>)
    }
  }

  render() {
    const { intentionPushHistory, usersById } = this.props
    const executor = get(usersById, intentionPushHistory.executor)

    return (
      <div style={{ marginBottom: '30px' }}>
        <div>
          {executor && executor.name}
          在
          {' '}
          {date(intentionPushHistory.createdAt, 'full')}
          {' '}
          进行
          {states[intentionPushHistory.state]}
        </div>
        {
          intentionPushHistory.checkedCount &&
            <div>第{intentionPushHistory.checkedCount}次到店</div>
        }
        <div>{intentionPushHistory.note}</div>
        {this.renderCars()}
      </div>
    )
  }
}
