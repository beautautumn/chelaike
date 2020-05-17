import React from 'react'
import { Modal, Form, InputNumber, Button, Row, Col } from 'antd'
import styles from './EvaluateModal.scss'
import layoutConfig from '../../../utils/formItemLayoutFacory'

const FormItem = Form.Item

class EvaluateModal extends React.Component {

  handleNumberChange = (value) => {
    this.props.handleEvaluateChange(value)
  }

  render() {
    const { visible, onCancel, onOk, data, onEvaluate } = this.props
    return (
      <Modal title="评估"
        className={styles.evaluateModal}
        bodyStyle={{padding: 20}}
        visible={visible}
        onCancel={onCancel}
        onOk={onOk}
        width="500px"
        zIndex={1200}
        maskClosable={false}
      >
        {
          data.brandName ?
          (
            <div>
              <div className={styles.formItem}>
                <span className={styles.title}>车辆名称：</span>
                <span>{`${data.brandName} ${data.seriesName} ${data.styleName}`}</span>
              </div>
              <div className={styles.formItem}>
                <span className={styles.title}>检测报告：</span>
                <span>
                  {
                    data.checkReportUrl ? (<a target="_blank" href={data.checkReportUrl}>{data.checkReportUrl}</a>) : '-'
                  }
                </span>
              </div>
              <Form>
                <Row>
                  <Col span={10}>
                    <FormItem {...layoutConfig(8, 16)} label="车辆估值">
                      <InputNumber
                        disabled={data.disabled}
                        style={{ width: '100%' }}
                        value={data.estimatePriceWan}
                        onChange={this.handleNumberChange}
                        addonAfter="万元"/>
                    </FormItem>
                  </Col>
                  <Col span={2} className={styles.unit}>
                    万元
                  </Col>
                  <Col span={6}>
                    {
                      data.disabled ? null : (
                        <Button type="primary" className={styles.evaluateButton} onClick={onEvaluate}>车300估值</Button>
                      )
                    }
                  </Col>
                </Row>
              </Form>
            </div>
          ) : null
        }

      </Modal>
    )
  }
}

export default EvaluateModal
