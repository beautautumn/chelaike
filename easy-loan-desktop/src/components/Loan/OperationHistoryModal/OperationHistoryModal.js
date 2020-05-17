import React from 'react'
import { Modal, Timeline } from 'antd'
import styles from './OperationHistoryModal.scss'

class OperationHistoryModal extends React.Component {

  render() {
    const { historyVisible, onCancel, data, statusMap } = this.props

    return (
      <Modal title="操作历史"
        className={styles.operationHistoryModal}
        bodyStyle={{padding: 50}}
        visible={historyVisible}
        onCancel={onCancel}
        width="600px"
        footer={null}
        maskClosable={false}
      >
        <Timeline>
          {
            data ? data.map((item, key) => {
              return (
                <Timeline.Item key={key} color="#e9e9e9">
                  <div>{[statusMap[item.contentState], item.message].join('，')}</div>
                  <div>{item.note}</div>
                  <div>
                    操作人：{item.operatorName}
                    <span className={styles.createdAt}>{item.createdAt}</span>
                  </div>
                </Timeline.Item>
              )
            }) : null
          }
        </Timeline>
      </Modal>
    )
  }
}

export default OperationHistoryModal

