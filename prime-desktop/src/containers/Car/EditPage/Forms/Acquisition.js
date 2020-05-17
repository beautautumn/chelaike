import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux-polymorphic'
import { Radio, Row, Col, Input } from 'antd'
import { NumberInput } from '@prime/components'
import {
  ShopSelect, UserSelect, Datepicker,
  BrandSelectGroup, BrandSelect, SeriesSelect,
  Select, ChannelSelect, NewChannelButton,
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
  'car.id', 'car.shopId', 'car.acquirerId', 'car.acquiredAt', 'car.brandName',
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
      acquirerId,
      acquiredAt,
      brandName,
      seriesName,
      styleName,
      level,
      mileage,
      mileageInFact,
      channelId,
      acquisitionType,
      licensedAt,
      acquisitionPriceWan,
      consignorName,
      consignorPhone,
      consignorPriceWan
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

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="所属分店：" required field={shopId}>
              {justOperateOneShop ?
                <Input value={acquisitionShops[0].name} disabled /> :
                <ShopSelect {...shopId} />
              }
            </FormItem>
          </Col>
        </Row>

        {(isNewCar || can('收购信息查看')) &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="收购员：" required field={acquirerId}>
                <UserSelect {...acquirerId} as="all" />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="收购日期：" required field={acquiredAt}>
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
              <FormItem {...formItemLayout} required field={keyCount} label="钥匙数量：">
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

        {(isNewCar || can('收购信息查看')) &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="收购渠道：" required field={channelId}>
                <Col span="21">
                  <ChannelSelect {...channelId} />
                </Col>
                <Col span="2" offset="1">
                  <NewChannelButton onSubmit={this.handleSubmitChannel} />
                </Col>
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="收购类型：" required field={acquisitionType}>
                <Radio.Group
                  {...acquisitionType}
                  onChange={event => acquisitionType.onChange(event.target.value)}
                >
                  <Radio value="acquisition">收购</Radio>
                  <Radio value="consignment">寄卖</Radio>
                  <Radio value="cooperation">合作</Radio>
                  <Radio value="permute">置换</Radio>
                </Radio.Group>
              </FormItem>
            </Col>
          </Row>
        }

        {(isNewCar || (can('收购信息查看') && can('收购价格查看'))) &&
          <Row>
            {acquisitionType.value !== 'consignment' &&
              <Col span="12">
                <FormItem {...formItemLayout} required field={acquisitionPriceWan} label="收购价：">
                  <NumberInput addonAfter="万元" {...acquisitionPriceWan} />
                </FormItem>
              </Col>
            }
          </Row>
        }

        {acquisitionType.value === 'consignment' && [
          <Row key="0">
            <Col span="12">
              <FormItem {...formItemLayout} label="寄卖人：" required field={consignorName}>
                <Input {...consignorName} />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="电话：" required field={consignorPhone}>
                <Input {...consignorPhone} />
              </FormItem>
            </Col>
          </Row>,
          <Row key="1">
            <Col span="12">
              <FormItem {...formItemLayout} field={consignorPriceWan} label="寄卖价：">
                <NumberInput addonAfter="万元" {...consignorPriceWan} />
              </FormItem>
            </Col>
          </Row>
        ]}
        {this.renderCooperationCompanyForm()}
      </Element>
    )
  }
}

Acquisition.fields = fields

export default Acquisition
