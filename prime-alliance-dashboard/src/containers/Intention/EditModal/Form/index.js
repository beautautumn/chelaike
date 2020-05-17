import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { Form as AForm, Input, Radio, Row, Col, Button, Icon, Switch } from 'antd'
import { NumberInput } from '@prime/components'
import {
  FormItem,
  Select,
  RegionSelectGroup,
  BrandSelectGroup,
  ColorInput,
  Datepicker,
  RadioGroup,
} from 'components'
import { AddCarButton, CarList } from 'containers/Intention/components'
import { autoId } from 'decorators'
import validation from './validation'
import date from 'helpers/date'

const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 17 },
}

@reduxForm({
  form: 'intention',
  fields: [
    'id', 'intentionType', 'allianceState', 'customerName', 'gender', 'customerPhone',
    'channelId', 'province', 'city', 'minimumPriceWan', 'maximumPriceWan',
    'seekingCars[].brandName', 'seekingCars[].seriesName', 'brandName',
    'seriesName', 'mileage', 'color', 'licensedAt', 'intentionNote',
    'appoitment', 'appoitmentCar.appointmentTime', 'appoitmentCar.carId',
    'appoitmentCar.note', 'allianceIntentionLevelId', 'createdAt',
  ],
  validate: validation,
})
@autoId
export default class Form extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    autoId: PropTypes.func.isRequired,
    enumValues: PropTypes.object.isRequired,
    handleAddCar: PropTypes.func.isRequired,
    carsById: PropTypes.object,
  }

  handleCarIdChange = ids => {
    this.props.fields.appoitmentCar.carId.onChange(ids[0])
  }

  renderSeekingCarsInput() {
    const { fields: { seekingCars } } = this.props
    return seekingCars.map((car, index) => {
      const handleRemove = index => () => seekingCars.removeField(index)

      const removeButton = (
        <Col span="1">
          <Button
            type="primary"
            size="large"
            onClick={handleRemove(index)}
          >
            <Icon type="minus" />
          </Button>
        </Col>
      )

      return (
        <BrandSelectGroup key={index} as="all">
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="品牌：">
                <BrandSelectGroup.Brand {...car.brandName} />
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 20 }} label="车系：">
                <BrandSelectGroup.Series {...car.seriesName} />
              </FormItem>
            </Col>
            {index !== 0 && removeButton}
          </Row>
        </BrandSelectGroup>
      )
    })
  }

  renderSeekForm() {
    const { fields, handleAddCar, carsById } = this.props

    return (
      <div>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="预算：">
              <NumberInput placeholder="最低" {...fields.minimumPriceWan} addonAfter="万元" />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout}>
              <NumberInput placeholder="最高" {...fields.maximumPriceWan} addonAfter="万元" />
            </FormItem>
          </Col>
        </Row>

        {this.renderSeekingCarsInput()}

        <FormItem>
          <Button type="primary" size="large" onClick={() => fields.seekingCars.addField()}>
            添加意向车型
          </Button>
        </FormItem>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="预约看车">
              <Switch {...fields.appoitment} />
            </FormItem>
          </Col>
        </Row>

        {fields.appoitment.value &&
          <div>
            <Row>
              <Col span="12">
                <FormItem
                  {...formItemLayout}
                  required
                  label="预约时间"
                  field={fields.appoitmentCar.appointmentTime}
                >
                  <Datepicker {...fields.appoitmentCar.appointmentTime} />
                </FormItem>
              </Col>
            </Row>

            {fields.appoitmentCar.carId.value !== '' &&
              <Row>
                <Col>
                  <CarList cars={[carsById[fields.appoitmentCar.carId.value]]} />
                </Col>
              </Row>
            }

            <FormItem>
              <AddCarButton
                type="radio"
                handleAdd={handleAddCar}
                value={[fields.appoitmentCar.carId.value]}
                onChange={this.handleCarIdChange}
              />
            </FormItem>
          </div>
        }
      </div>
    )
  }

  renderSaleForm() {
    const { fields, enumValues, autoId } = this.props

    return (
      <div>
        <BrandSelectGroup as="all">
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="品牌">
                <BrandSelectGroup.Brand {...fields.brandName} />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label="车系">
                <BrandSelectGroup.Series {...fields.seriesName} />
              </FormItem>
            </Col>
          </Row>
        </BrandSelectGroup>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} id={autoId()} label="里程">
              <NumberInput id={autoId()} {...fields.mileage} addonAfter="万公里" />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} id={autoId()} label="外观颜色">
              <ColorInput
                colors={enumValues.car.exterior_color}
                id={autoId()}
                {...fields.color}
              />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="期望价格">
              <NumberInput placeholder="最低" {...fields.minimumPriceWan} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout}>
              <NumberInput placeholder="最高" {...fields.maximumPriceWan} addonAfter="万元" />
            </FormItem>
          </Col>
        </Row>

        <FormItem labelCol={{ span: 3 }} label="上牌年月">
          <Datepicker {...fields.licensedAt} format="month" />
        </FormItem>
      </div>
    )
  }

  render() {
    const { autoId, fields } = this.props

    return (
      <AForm horizontal>
        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} id={autoId()} label="客户姓名：">
              <Input id={autoId()} type="text" {...fields.customerName} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout}>
              <RadioGroup {...fields.gender}>
                <Radio key="male" value="male">先生</Radio>
                <Radio key="female" value="female">女士</Radio>
              </RadioGroup>
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem
              {...formItemLayout}
              id={autoId()}
              required
              label="联系电话："
              field={fields.customerPhone}
            >
              <Input id={autoId()} type="text" {...fields.customerPhone} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem
              {...formItemLayout}
              id={autoId()}
              required
              label="客户来源："
              field={fields.channelId}
            >
              <Select.Channel id={autoId()} {...fields.channelId} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem
              {...formItemLayout}
              id={autoId()}
              label="客户级别："
              field={fields.allianceIntentionLevelId}
            >
              <Select.IntentionLevel id={autoId()} {...fields.allianceIntentionLevelId} />
            </FormItem>
          </Col>
        </Row>

        <RegionSelectGroup>
          <Row>
            <Col span="12">
              <FormItem {...formItemLayout} label="归属地区">
                <RegionSelectGroup.Province {...fields.province} />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout}>
                <RegionSelectGroup.City {...fields.city} />
              </FormItem>
            </Col>
          </Row>
        </RegionSelectGroup>

        {fields.intentionType.value === 'seek' && this.renderSeekForm()}

        {fields.intentionType.value === 'sale' && this.renderSaleForm()}

        <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 20 }} id={autoId()} label="备注">
          <Input type="textarea" autosize id={autoId()} rows={4} {...fields.intentionNote} />
        </FormItem>

        <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 20 }} id={autoId()} label="创建时间">
          <Input type="text" value={date(fields.createdAt.value)} disabled />
        </FormItem>
      </AForm>
    )
  }
}
