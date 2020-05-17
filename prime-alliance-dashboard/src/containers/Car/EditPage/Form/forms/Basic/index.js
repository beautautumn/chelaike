import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Auth from 'models/auth'
import EnumValue from 'models/enumValue'
import { Row, Col, Input, Checkbox, Radio } from 'antd'
import { NumberInput } from '@prime/components'
import {
  Select,
  ColorInput,
  Datepicker,
  FormItem,
} from 'components'
import { formOptimize } from 'decorators'
import map from 'lodash/map'
import { Element } from 'react-scroll'
import styles from '../../style.scss'

function mapStateToProps(_state) {
  return {
    ...EnumValue.select('carStates'),
    currentUser: Auth.getState().user,
    enumValues: EnumValue.getState(),
  }
}

const fields = [
  'car.id', 'car.name', 'car.stockNumber', 'car.vin', 'car.state',
  'car.stateNote', 'car.carType', 'car.doorCount', 'car.displacement',
  'car.isTurboCharger', 'car.fuelType', 'car.transmission', 'car.emissionStandard',
  'car.exteriorColor', 'car.interiorColor', 'car.manufacturedAt',
  'acquisitionTransfer.compulsoryInsurance', 'acquisitionTransfer.compulsoryInsuranceEndAt',
  'acquisitionTransfer.commercialInsurance', 'acquisitionTransfer.commercialInsuranceEndAt',
  'acquisitionTransfer.commercialInsuranceAmountYuan', 'acquisitionTransfer.annualInspectionEndAt',
]

@connect(mapStateToProps)
@formOptimize(fields)
class Basic extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
    inStockCarStates: PropTypes.object.isRequired,
  }

  render() {
    const formItemLayout = {
      labelCol: { span: 4 },
      wrapperCol: { span: 19 },
    }

    const {
      id, name, stockNumber, vin,
      state, stateNote, carType, doorCount,
      displacement, isTurboCharger, fuelType,
      transmission, emissionStandard, exteriorColor,
      interiorColor, manufacturedAt,
    } = this.props.fields.car

    const {
      annualInspectionEndAt, compulsoryInsurance, compulsoryInsuranceEndAt,
      commercialInsurance, commercialInsuranceEndAt, commercialInsuranceAmountYuan,
    } = this.props.fields.acquisitionTransfer

    const { inStockCarStates, enumValues } = this.props

    return (
      <Element name="basic" className={styles.formPanel}>
        <div className={styles.formPanelTitle}>基本信息</div>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="宣传标题：" field={name} required>
              <Input {...name} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="库存编号：" >
              <Input placeholder="不填则由系统自动分配" {...stockNumber} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="车架号：" >
              <Input {...vin} />
            </FormItem>
          </Col>
        </Row>

        {!id.value &&
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="车辆状态：" >
                <Select
                  items={map(inStockCarStates, (text, key) => ({ value: key, text }))}
                  {...state}
                />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="状态备注：" >
                <Input {...stateNote} />
              </FormItem>
            </Col>
          </Row>
        }

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="车型：" >
              <Select
                items={map(enumValues.car.car_type, (text, key) => ({ value: key, text }))}
                {...carType}
              />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="车门数：" >
              <NumberInput addonAfter="门" {...doorCount} />
            </FormItem>
          </Col>
        </Row>

        <FormItem labelCol={{ span: 2 }} wrapperCol={{ span: 19 }} label="排气量：" >
          <Col span="5">
            <Input addonAfter={isTurboCharger.value ? 'T' : 'L'} {...displacement} />
          </Col>
          <Col span="3" offset="1">
            <label>
              <Checkbox
                {...isTurboCharger}
                onChange={event => isTurboCharger.onChange(event.target.checked)}
              />涡轮增压
            </label>
          </Col>
          <Col>
            <Radio.Group {...fuelType} onChange={event => fuelType.onChange(event.target.value)}>
            {Object.keys(enumValues.car.fuel_type).reduce((accumulator, key) => {
              accumulator.push(
                <Radio key={key} value={key}>{enumValues.car.fuel_type[key]}</Radio>
              )
              return accumulator
            }, [])}
            </Radio.Group>
          </Col>
        </FormItem>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="变速箱：" >
              <Select
                items={map(enumValues.car.transmission, (text, key) => ({ value: key, text }))}
                {...transmission}
              />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="排放标准：" >
              <Select
                items={map(enumValues.car.emission_standard, (text, key) => ({ value: key, text }))}
                {...emissionStandard}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="外观颜色：" >
              <ColorInput colors={enumValues.car.exterior_color} {...exteriorColor} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="内饰颜色：" >
              <ColorInput colors={enumValues.car.interior_color} {...interiorColor} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="交强险：" >
              <Col span="7">
                <Radio.Group
                  {...compulsoryInsurance}
                  onChange={event => compulsoryInsurance.onChange(event.target.value)}
                >
                  <Radio value>有</Radio>
                  <Radio value={false}>无</Radio>
                </Radio.Group>
              </Col>
              <Col>
                {compulsoryInsurance.value &&
                  <Datepicker format="month" placeholder="到期日期" {...compulsoryInsuranceEndAt} />
                }
              </Col>
            </FormItem>
          </Col>

          <Col span="12">
            <FormItem {...formItemLayout} label="商业险：" >
              <Col span="7">
                <Radio.Group
                  {...commercialInsurance}
                  onChange={event => commercialInsurance.onChange(event.target.value)}
                >
                  <Radio value>有</Radio>
                  <Radio value={false}>无</Radio>
                </Radio.Group>
              </Col>
              <Col span="7">
                {commercialInsurance.value &&
                  <Datepicker format="month" placeholder="到期日期" {...commercialInsuranceEndAt} />
                }
              </Col>
              <Col span="9" offset="1">
                {commercialInsurance.value &&
                  <NumberInput
                    placeholder="商业险金额"
                    addonAfter="元"
                    {...commercialInsuranceAmountYuan}
                  />
                }
              </Col>
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="年审到期：" >
              <Datepicker format="month" {...annualInspectionEndAt} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="出厂日期：" >
              <Datepicker format="month" {...manufacturedAt} />
            </FormItem>
          </Col>
        </Row>
      </Element>
    )
  }
}

Basic.fields = fields

export default Basic
