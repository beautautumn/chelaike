import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Oss, { shouldFetch } from 'models/oss'
import Auth from 'models/auth'
import EnumValue from 'models/enumValue'
import { Row, Tabs } from 'antd'
import { canEditAcquisitionTransfer } from 'helpers/can'
import { ImageManager } from 'components'
import { formOptimize } from 'decorators'
import { Element } from 'react-scroll'
import cx from 'classnames'
import styles from '../../style.scss'

const { TabPane } = Tabs

function mapStateToProps(_state) {
  return {
    currentUser: Auth.getState().user,
    oss: Oss.getState(),
    tranferLocations: EnumValue.getState().transfer_record.items,
  }
}

const fields = [
  'car.id', 'car.imagesAttributes', 'acquisitionTransfer.imagesAttributes',
]

const carLocations = [
  '左前45度',
  '前排座椅-左前门',
  '左侧面',
  '后排座椅-左后门',
  '左后45度',
  '后面',
  '后备箱',
  '右后45度',
  '后排座椅-右后门',
  '右侧面',
  '前排座椅-右前门',
  '右前45度',
  '正面',
  '发动机舱',
  '轮毂',
  '中控台',
  '里程表',
  '内饰',
  '天窗',
  '其他',
]

@connect(mapStateToProps)
@formOptimize(fields)
class Images extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    fields: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    oss: PropTypes.object.isRequired,
    tranferLocations: PropTypes.object.isRequired,
  }

  componentDidMount() {
    const { dispatch, oss } = this.props
    if (shouldFetch(oss)) {
      dispatch(Oss.fetch())
    }
  }

  render() {
    const { oss, tranferLocations } = this.props
    const { id } = this.props.fields.car
    const carImagesAttributes = this.props.fields.car.imagesAttributes
    const acquisitionTransferImages = this.props.fields.acquisitionTransfer.imagesAttributes

    return (
      <Element name="images" className={cx(styles.formPanel, styles.additionalBottoMargin)}>
        <div className={styles.formPanelTitle}>图片管理</div>
        <Row className={styles.form}>
          <Tabs defaultActiveKey="1" >
            <TabPane tab="车辆图片" key="1">
              <ImageManager oss={oss} locations={carLocations} hasCover {...carImagesAttributes} />
            </TabPane>
            <TabPane
              tab="牌证图片"
              key="2"
              disabled={!canEditAcquisitionTransfer(id.value)}
            >
              <ImageManager
                oss={oss}
                locations={tranferLocations}
                hasCover={false}
                {...acquisitionTransferImages}
              />
            </TabPane>
          </Tabs>
        </Row>
      </Element>
    )
  }
}

Images.fields = fields

export default Images
