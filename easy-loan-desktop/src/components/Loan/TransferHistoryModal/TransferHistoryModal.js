import React from 'react'
import { Modal } from 'antd'
import styles from './TransferHistoryModal.scss'
import { CarItem } from 'components'

class TransferHistoryModal extends React.Component {

  renderHistory(history, key) {
    const { showEvaluateModal } = this.props
    return (
      <div className={styles.historyItem} key={key}>
        <div className={`${styles.column} ${styles.historyHeader}`}>
          <div className={`${styles.alignLeft} ${styles.item}`}>
            第{history.count}批换车{history.carNum}台
          </div>
          <div className={`${styles.alignRight} ${styles.item}`}>
            {history.createdAt}
          </div>
        </div>
        <div className={styles.carList}>
          {
            history.cars.map((car, carIndex) => {
              car.disabled = true
              return (<CarItem
                showEvaluateModal={showEvaluateModal}
                item={car}
                key={carIndex} />)
            })
          }
        </div>
      </div>
    )
  }

  render() {
    const { historyVisible, onCancel, data, showEvaluateModal } = this.props
    return (
      <Modal title="换车历史"
        className={styles.transferHistoryModal}
        bodyStyle={{padding: 0}}
        visible={historyVisible}
        onCancel={onCancel}
        width="600px"
        footer={null}
        maskClosable={false}
      >
        {
          data ? data.transferCarHistoryDtos.map((item, key) => {
            return this.renderHistory(item, key)
          }) : null
        }
        {
          data ? (
            <div className={styles.historyItem}>
              <div className={`${styles.column} ${styles.historyHeader}`}>
                <div className={`${styles.alignLeft} ${styles.item}`}>
                  初始借款车辆{data.originCars.length}台
                </div>
                <div className={`${styles.alignRight} ${styles.item}`}>
                  {data.createTime}
                </div>
              </div>
              <div className={styles.carList}>
                {
                  data.originCars.map((car, carIndex) => {
                    car.disabled = true
                    return (<CarItem
                      showEvaluateModal={showEvaluateModal}
                      item={car}
                      key={carIndex} />)
                  })
                }
              </div>
            </div>
           ) : null
        }

      </Modal>
    )
  }
}

export default TransferHistoryModal

