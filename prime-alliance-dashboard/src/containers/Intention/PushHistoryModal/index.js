import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Intention from 'models/intention/intention'
import PushHistory from 'models/intention/pushHistory'
import { Modal, Timeline } from 'antd'
import date from 'helpers/date'
import { connectModal } from 'redux-modal'

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
  online_consignment: '网寄',
}

@connectModal({ name: 'pushHistory' })
@connect(
  (_state, { id }) => ({
    pushHistories: PushHistory.select('orderList', id),
    intention: Intention.select('one', id),
  })
)
export default class PushHistoryModal extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired,
    pushHistories: PropTypes.array.isRequired,
    intention: PropTypes.object.isRequired,
    handleHide: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { dispatch, intention } = this.props
    dispatch(PushHistory.fetch(intention.id))
  }

  render() {
    const { pushHistories, intention, show, handleHide } = this.props
    return (
      <Modal
        title={`${intention.customerName || intention.customerPhone}的跟进历史`}
        width={760}
        maskClosable={false}
        visible={show}
        onCancel={handleHide}
        onOk={handleHide}
      >
        <div className="content">
          <Timeline>
            {pushHistories.map(pushHistory => (
              <Timeline.Item key={pushHistory.id}>
                <p>
                  {pushHistory.executor && pushHistory.executor.name}
                  进行“{states[pushHistory.state]}”操作
                </p>
                {pushHistory.checkedCount &&
                  <p>
                    第{pushHistory.checkedCount}次到店
                  </p>
                }
                {pushHistory.closingCarName &&
                  <p>
                    成交车辆：{pushHistory.closingCarName}
                  </p>
                }
                {pushHistory.closingCar &&
                  <p>
                    成交车辆：{`${pushHistory.closingCar.name}
                    （${pushHistory.closingCar.stockNumber}）`}
                  </p>
                }
                {pushHistory.interviewedTime &&
                  <p>
                    下次预约时间：{date(pushHistory.interviewedTime)}
                  </p>
                }
                {pushHistory.processingTime &&
                  <p>
                    下次跟进时间：{date(pushHistory.processingTime)}
                  </p>
                }
                {pushHistory.note &&
                  <p>
                    跟进说明：{pushHistory.note}
                  </p>
                }
                <p>{date(pushHistory.createdAt, 'full')}</p>
              </Timeline.Item>
            ))}
          </Timeline>
        </div>
      </Modal>
    )
  }
}
