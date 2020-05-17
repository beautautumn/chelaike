import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Auth from 'models/auth'
import EnumValue from 'models/enumValue'
import { Radio, Row, Col, Input } from 'antd'
import { NumberInput } from '@prime/components'
import {
  Datepicker,
  BrandSelectGroup,
  Select,
  FormItem,
  RadioGroup,
} from 'components'
import { formOptimize } from 'decorators'
import can, { canEditAcquisitionTransfer } from 'helpers/can'
import { Element } from 'react-scroll'
import CooperationCompanyForm from './CooperationCompanyForm'
import Style from './Style'
import styles from '../../style.scss'

const formItemLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 19 },
}

function mapStateToProps(_state) {
  return {
    currentUser: Auth.getState().user,
    enumValues: EnumValue.getState(),
  }
}

const fields = [
  'car.id', 'car.acquirerId', 'car.acquiredAt', 'car.brandName',
  'car.seriesName', 'car.styleName', 'car.mileage', 'car.mileageInFact',
  'car.channelId', 'car.acquisitionType', 'car.acquisitionPriceWan',
  'car.consignorName', 'car.consignorPhone', 'car.consignorPriceWan',
  'car.cooperationCompanyRelationshipsAttributes', 'acquisitionTransfer.keyCount',
  'car.licenseInfo', 'car.licensedAt', 'car.level', 'car.name', 'car.companyId',
]

@connect(mapStateToProps)
@formOptimize(fields)
class Acquisition extends Component {
  static propTypes = {
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
  }

  renderLicenseInfo() {
    const { license_info } = this.props.enumValues.car
    const { licenseInfo, licensedAt } = this.props.fields.car
    const radios = (
      <RadioGroup {...licenseInfo}>
        {Object.keys(license_info).reduce((accumulator, key) => {
          accumulator.push(
            <Radio key={key} value={key}>{license_info[key]}</Radio>
          )
          return accumulator
        }, [])}
      </RadioGroup>
    )

    let licensedAtInput
    if (licenseInfo.value === 'licensed') {
      licensedAtInput = (
        <Datepicker format="month" placeholder="上牌日期" {...licensedAt} />
      )
    }
    return [
      <Col key="1" span="12">
        {radios}
      </Col>,
      <Col key="2" span="10">
        {licensedAtInput}
      </Col>,
    ]
  }

  renderCooperationCompanyForm() {
    const {
      acquisitionType,
      cooperationCompanyRelationshipsAttributes,
    } = this.props.fields.car
    let cooperationCompanyForm
    if (acquisitionType.value === 'cooperation') {
      cooperationCompanyForm = (
        <CooperationCompanyForm {...cooperationCompanyRelationshipsAttributes} />
      )
    }
    return cooperationCompanyForm
  }

  render() {
    const { car } = this.props

    const {
      id,
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
      consignorPriceWan,
    } = this.props.fields.car

    const isNewCar = !id.value

    const { keyCount } = this.props.fields.acquisitionTransfer

    const levels = ['A级', 'B级', 'C级', 'D级'].reduce((accumulator, item) => {
      accumulator.push({ value: item, text: item })
      return accumulator
    }, [])


    return (
      <Element name="acquisition" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>收购信息</div>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="所属车商：">
              <Input value={car.company.nickname} disabled />
            </FormItem>
          </Col>
        </Row>

        {(isNewCar || can('收购信息查看')) &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="收购员：" required field={acquirerId}>
                <Select.User {...acquirerId} as="all" />
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
                    <BrandSelectGroup.Brand {...brandName} />
                  </Col>
                  <Col span="12" offset="1">
                    <BrandSelectGroup.Series {...seriesName} />
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
              <FormItem {...formItemLayout} label="钥匙数量：">
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
                  <Select.Channel {...channelId} query={car.companyId} />
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
                <FormItem {...formItemLayout} field={acquisitionPriceWan} label="收购价：">
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
          </Row>,
        ]}
        <Row>
          {this.renderCooperationCompanyForm()}
        </Row>
      </Element>
    )
  }
}

Acquisition.fields = fields

export default Acquisition
