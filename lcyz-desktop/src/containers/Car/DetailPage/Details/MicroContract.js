import React from 'react'
import date from 'helpers/date'
import { Element } from 'react-scroll'
import { Segment } from 'components'
import { Row, Col } from 'antd'
import styles from '../DetailPage.scss'
import items from 'containers/License/EditModal/SalesForm/items'

function buildItemsName(keys) {
  if (!keys || keys.length === 0) return '未填写，请去牌证信息编辑页补充填写'
  const ans = []
  for (const key of keys) {
    for (const item of items) {
      if (item.key === key) {
        ans.push(item.text)
        break
      }
    }
  }
  return ans.join('，')
}

export default ({ car, transfersById }) => (
  <Element name="microContract">
    <Segment className="ui grid segment">
      <div className="sixteen wide column">
        <h3 className="ui dividing header">联盟微合同</h3>
        {car.microContract &&
          <div>
            <Row type="flex" justify="center">
              <h3>{car.microContract.allianceName}交易微合同</h3>
            </Row>
            <Row className={styles.contractInfo}>
              <Col offset="2" span="3">卖方</Col>
              <Col span="17">{car.microContract.fromCompanyName}</Col>

              <Col offset="2" span="3">买方</Col>
              <Col span="17">{car.microContract.toCompanyName}</Col>

              <Col offset="2" span="3">签订日期</Col>
              <Col span="17">{date(car.microContract.completedAt)}</Col>

              <Col offset="2" span="3">成交价（万元）</Col>
              <Col span="17">{car.microContract.closingCostWan}</Col>

              <Col offset="2" span="3">定金（万元）</Col>
              <Col span="17">{car.microContract.depositWan}</Col>

              <Col offset="2" span="3" className={styles.noBorder}>余款（万元）</Col>
              <Col span="17" className={styles.noBorder}>{car.microContract.remainingMoneyWan}</Col>
            </Row>

            <Row className={styles.contractCarHeader}>
              <Col offset="2" span="20">
                <h5>车辆信息</h5>
              </Col>
            </Row>

            <Row className={styles.contractCarInfo}>
              <Col offset="2" span="3">品牌车型</Col>
              <Col span="17">{car.systemName}</Col>

              <Col offset="2" span="3">出厂年月</Col>
              <Col span="17">{car.manufacturedAt}</Col>

              <Col offset="2" span="3">上牌年月</Col>
              <Col span="17">{car.licensedAt}</Col>

              <Col offset="2" span="3">车架号</Col>
              <Col span="17">{car.vin}</Col>

              <Col offset="2" span="3">发动机号</Col>
              <Col span="17">
                {
                  car.acquisitionTransfer &&
                  transfersById[car.acquisitionTransfer].engineNumber
                }
              </Col>

              <Col offset="2" span="3">原车牌号</Col>
              <Col span="17">{car.currentPlateNumber}</Col>

              <Col offset="2" span="3">颜色</Col>
              <Col span="17">{car.exteriorColor}/{car.interiorColor}</Col>

              <Col offset="2" span="3">公里</Col>
              <Col span="17">{car.mileage}</Col>

              <Col offset="2" span="3">排量</Col>
              <Col span="17">{car.displacement}</Col>

              <Col offset="2" span="3">配置说明</Col>
              <Col span="17">{car.configurationNote}</Col>

              <Col offset="2" span="3">新车指导价</Col>
              <Col span="17">{car.newCarGuidePriceWan}</Col>

              <Col offset="2" span="3">新车完税价</Col>
              <Col span="17">{car.newCarFinalPriceWan}</Col>

              <Col offset="2" span="3">过户次数</Col>
              <Col span="17">
                {
                  car.acquisitionTransfer &&
                  transfersById[car.acquisitionTransfer].transferCount
                }
              </Col>

              <Col offset="2" span="3">瑕疵描述</Col>
              <Col span="17">{car.interiorNote}</Col>

              <Col offset="2" span="3">钥匙数</Col>
              <Col span="17">
                {
                  car.acquisitionTransfer &&
                  transfersById[car.acquisitionTransfer].keyCount
                }
              </Col>

              <Col offset="2" span="3">交强险到时</Col>
              <Col span="17">
                {
                  car.acquisitionTransfer &&
                  date(transfersById[car.acquisitionTransfer].compulsoryInsuranceEndAt)
                }
              </Col>

              <Col offset="2" span="3">手续资料</Col>
              <Col span="17">
                {
                  car.acquisitionTransfer &&
                  buildItemsName(transfersById[car.acquisitionTransfer].items)
                }
              </Col>

              <Col offset="2" span="3">随车附件</Col>
              <Col span="17" />

              <Col offset="2" span="3">备注</Col>
              <Col span="17">{car.microContract.note}</Col>
            </Row>
          </div>
        }
      </div>
    </Segment>
  </Element>
)
