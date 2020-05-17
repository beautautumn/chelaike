import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { Radio, Row, Col } from 'antd'
import { NumberInput } from '@prime/components'
import {
  CarShopCompanySelectGroup, CarShopSelect, CarCompanySelect, UserSelect, Datepicker,
  BrandSelectGroup, BrandSelect, SeriesSelect, Select,
  FormItem
} from 'components'
import { formOptimize } from 'decorators'
import Style from '../Inputs/Style'
import CooperationCompanyForm from '../Inputs/CooperationCompanyForm'
import { create as createChannel } from 'redux/modules/channels'
import can, { canEditAcquisitionTransfer } from 'helpers/can'
import { change as changeFieldValue } from 'redux-form'
import styles from './Form.scss'
import { Element } from 'react-scroll'

const formItemLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 19 },
}

function mapStateToProps(state) {
  return {
    currentUser: state.auth.user,
    enumValues: state.enumValues,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    ...bindActionCreators({
      createChannel,
      changeFieldValue,
    }, dispatch, 'inStock')
  }
}

const fields = [
  'car.id', 'car.shopId', 'car.ownerCompanyId', 'car.acquirerId', 'car.acquiredAt', 'car.brandName',
  'car.seriesName', 'car.styleName', 'car.mileage', 'car.mileageInFact',
  'car.channelId', 'car.acquisitionType', 'car.acquisitionPriceWan',
  'car.consignorName', 'car.consignorPhone', 'car.consignorPriceWan',
  'car.cooperationCompanyRelationshipsAttributes', 'acquisitionTransfer.keyCount',
  'car.licenseInfo', 'car.licensedAt', 'car.level', 'car.name'
]

@connect(mapStateToProps, mapDispatchToProps)
@formOptimize(fields)
class Acquisition extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    createChannel: PropTypes.func.isRequired,
    currentUser: PropTypes.object.isRequired,
    changeFieldValue: PropTypes.func.isRequired,
  }

  handleSubmitChannel = (data) => {
    if (data && data.name) {
      this.props.createChannel(data)
        .then((responseData) => {
          this.props.changeFieldValue('car', 'car.channelId', responseData.payload.result)
        })
    }
  }

  renderLicenseInfo() {
    const { license_info } = this.props.enumValues.car
    const { licenseInfo, licensedAt } = this.props.fields.car
    const radios = (
      <Radio.Group {...licenseInfo} onChange={event => licenseInfo.onChange(event.target.value)}>
      {Object.keys(license_info).reduce((accumulator, key) => {
        accumulator.push(
          <Radio key={key} value={key}>{license_info[key]}</Radio>
        )
        return accumulator
      }, [])}
      </Radio.Group>
    )

    let licensedAtInput
    if (licenseInfo.value === 'licensed') {
      licensedAtInput = (
        <Datepicker format="month" placeholder="上牌年月" {...licensedAt} />
      )
    }
    return [
      <Col key="1" span="12">
        {radios}
      </Col>,
      <Col key="2" span="10">
        {licensedAtInput}
      </Col>
    ]
  }

  renderCooperationCompanyForm() {
    const {
      acquisitionType,
      cooperationCompanyRelationshipsAttributes
    } = this.props.fields.car
    if (acquisitionType.value === 'cooperation') {
      return (
        <CooperationCompanyForm {...cooperationCompanyRelationshipsAttributes} />
      )
    }
  }

  render() {
    const {
      id,
      shopId,
      ownerCompanyId,
      acquirerId,
      acquiredAt,
      brandName,
      seriesName,
      styleName,
      level,
      mileage,
      mileageInFact,
      licensedAt,
    } = this.props.fields.car

    const isNewCar = !id.value

    const { keyCount } = this.props.fields.acquisitionTransfer

    const levels = ['A级', 'B级', 'C级', 'D级'].reduce((accumulator, item) => {
      accumulator.push({ value: item, text: item })
      return accumulator
    }, [])

    const acquisitionShops = this.props.currentUser.acquisitionShops
    const justOperateOneShop = acquisitionShops.length === 1

    return (
      <Element name="acquisition" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>收购信息</div>

        <CarShopCompanySelectGroup>
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="所属分店：" required field={shopId}>
                <CarShopSelect {...shopId} disabled={justOperateOneShop} />
              </FormItem>
            </Col>

            <Col span="12">
              <FormItem {...formItemLayout} label="归属车商：" required field={ownerCompanyId}>
                <CarCompanySelect {...ownerCompanyId} />
              </FormItem>
            </Col>
          </Row>
        </CarShopCompanySelectGroup>

        {(isNewCar || can('收购信息查看')) &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="车源负责：" required field={acquirerId}>
                <UserSelect {...acquirerId} as="all" />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="入库日期：" required field={acquiredAt}>
                <Datepicker {...acquiredAt} />
              </FormItem>
            </Col>
          </Row>
        }

        <BrandSelectGroup as="all">
          <Row>
            <Col span="12">
              <FormItem
                {...formItemLayout}
                label="品牌："
                required
                field={brandName}
              >
                <Row>
                  <Col span="11">
                    <BrandSelect {...brandName} />
                  </Col>
                  <Col span="12" offset="1">
                    <SeriesSelect {...seriesName} />
                  </Col>
                </Row>
              </FormItem>
            </Col>
            <Col span="12">
              <Style field={styleName} />
            </Col>
          </Row>
        </BrandSelectGroup>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="表显里程：" required field={mileage}>
              <NumberInput addonAfter="万公里" {...mileage} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="实际里程：">
              <NumberInput addonAfter="万公里" {...mileageInFact} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="车辆等级：">
              <Select items={levels} prompt="选择等级" {...level} />
            </FormItem>
          </Col>

          {canEditAcquisitionTransfer(id.value) &&
            <Col span="12">
              <FormItem {...formItemLayout} field={keyCount} label="钥匙数量：">
                <Radio.Group
                  {...keyCount}
                  onChange={event => keyCount.onChange(event.target.value)}
                >
                  <Radio key="a" value={1}>一把</Radio>
                  <Radio key="b" value={2}>两把</Radio>
                  <Radio key="c" value={3}>三把</Radio>
                </Radio.Group>
              </FormItem>
            </Col>
          }
        </Row>

        <Row>
          <Col span="16">
            <FormItem
              labelCol={{ span: 3 }}
              wrapperCol={{ span: 19 }}
              label="首次上牌："
              required
              field={licensedAt}
            >
              {this.renderLicenseInfo()}
            </FormItem>
          </Col>
        </Row>
      </Element>
    )
  }
}

Acquisition.fields = fields

export default Acquisition
