import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { fetch as fetchOss, shouldFetch } from 'redux/modules/oss'
import { Row, Tabs } from 'antd'
import { canEditAcquisitionTransfer } from 'helpers/can'
import { ImageManager } from 'components'
import { formOptimize } from 'decorators'
import styles from './Form.scss'
import { Element } from 'react-scroll'

const { TabPane } = Tabs

function mapStateToProps(state) {
  return {
    currentUser: state.auth.user,
    oss: state.oss,
    tranferLocations: state.enumValues.transfer_record.items,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    ...bindActionCreators({
      fetchOss,
    }, dispatch, 'inStock')
  }
}

const fields = [
  'car.id', 'car.imagesAttributes', 'acquisitionTransfer.imagesAttributes'
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
  '其他'
]

@connect(mapStateToProps, mapDispatchToProps)
@formOptimize(fields)
class Images extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    oss: PropTypes.object.isRequired,
    fetchOss: PropTypes.func.isRequired,
    tranferLocations: PropTypes.object.isRequired,
  }

  componentDidMount() {
    if (shouldFetch(this.props.oss)) {
      this.props.fetchOss()
    }
  }

  render() {
    const { oss, tranferLocations } = this.props
    const { id } = this.props.fields.car
    const carImagesAttributes = this.props.fields.car.imagesAttributes
    const acquisitionTransferImages = this.props.fields.acquisitionTransfer.imagesAttributes

    return (
      <Element name="images" className={styles.formPanel + ' ' + styles.additionalBottoMargin}>
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
