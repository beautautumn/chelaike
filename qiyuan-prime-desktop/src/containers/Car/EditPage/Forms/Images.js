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
  { key: 'left_anterior', label: '左前45°·首图' },
  { key: 'right_rear', label: '右后45°' },
  { key: 'right_slide', label: '正侧面' },
  { key: 'control_booth', label: '中控台全景' },
  { key: 'odograph', label: '里程表' },
  { key: 'driving_seat', label: '主驾座椅' },
  { key: 'open_trunk', label: '后备箱（打开）' },
  { key: 'engine_bay', label: '发动机舱全景' },
  { key: 'tyre', label: '轮胎' },
  { key: 'vin', label: 'VIN码或铭牌' },
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
