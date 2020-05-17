import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { reduxForm } from 'redux-form'
import Textarea from 'react-textarea-autosize'
import {
  ChannelSelect,
  RegionSelectGroup,
  ProvinceSelect,
  CitySelect,
  BrandSelectGroup,
  BrandSelect,
  SeriesSelect,
  ColorInput,
  Datepicker,
  FormItem,
} from 'components'
import validation from './validation'
import { Form as AForm, Input, Radio, Row, Col, Button } from 'antd'
import { NumberInput } from '@prime/components'
const InputGroup = Input.Group
const RadioGroup = Radio.Group

const formItemLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 15 },
}

const firstColLayout = {
  labelCol: { span: 8 },
  wrapperCol: { span: 14 },
}

const secondColLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 10 },
}

@reduxForm({
  form: 'intention',
  fields: [
    'id', 'intentionType', 'state', 'customerName', 'gender', 'customerPhone',
    'channelId', 'province', 'city', 'minimumPriceWan', 'maximumPriceWan',
    'seekingCars[].brandName', 'seekingCars[].seriesName', 'brandName',
    'seriesName', 'mileage', 'color', 'licensedAt', 'intentionNote'
  ],
  validate: validation
})
export default class Form extends PureComponent {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    readOnlyChannel: PropTypes.object,
  }

  renderSeekingCarsInput() {
    const { fields: { seekingCars } } = this.props
    return seekingCars.map((car, index) => {
      const handleRemove = index => () => seekingCars.removeField(index)

      const removeButton = (
        <Button type="primary" icon="minus" onClick={handleRemove(index)} />
      )

      return (
        <FormItem {...formItemLayout} label="品牌／车系：" key={index}>
          <BrandSelectGroup as="all">
            <InputGroup>
              <Col span="12">
                <BrandSelect {...car.brandName} />
              </Col>
              <Col span="10">
                <SeriesSelect {...car.seriesName} />
              </Col>
              <Col span="2">
                {index !== 0 && removeButton}
              </Col>
            </InputGroup>
          </BrandSelectGroup>
        </FormItem>
      )
    })
  }

  renderSeekIntentionForm() {
    const { fields } = this.props

    if (fields.intentionType.value !== 'seek') return null

    return (
      <div>
        <FormItem {...formItemLayout} label="预算：">
          <InputGroup>
            <Col span="12">
              <NumberInput placeholder="最低" addonAfter="万元" {...fields.minimumPriceWan} />
            </Col>
            <Col span="12">
              <NumberInput placeholder="最高"i addonAfter="万元" {...fields.maximumPriceWan} />
            </Col>
          </InputGroup>
        </FormItem>

        {this.renderSeekingCarsInput()}

        <Row>
          <Col offset="4" style={{ paddingBottom: '20px' }}>
            <Button
              type="primary"
              onClick={() => fields.seekingCars.addField()}
            >
              添加意向车型
            </Button>
          </Col>
        </Row>
      </div>
    )
  }

  renderSaleIntentionForm() {
    const { fields, enumValues } = this.props

    if (fields.intentionType.value !== 'sale') return null

    return (
      <div>
        <FormItem {...formItemLayout} label="品牌／车系：">
          <BrandSelectGroup as="all">
            <InputGroup>
              <Col span="12">
                <BrandSelect {...fields.brandName} />
              </Col>
              <Col span="12">
                <SeriesSelect {...fields.seriesName} />
              </Col>
            </InputGroup>
          </BrandSelectGroup>
        </FormItem>

        <Row>
          <Col span="12">
            <FormItem {...firstColLayout} label="里程：" >
              <NumberInput {...fields.mileage} addonAfter="万公里" />
            </FormItem>
          </Col>
          <Col span="12" pull="1">
            <FormItem {...secondColLayout} label="外观颜色：" >
              <ColorInput
                colors={enumValues.car.exterior_color}
                {...fields.color}
              />
            </FormItem>
          </Col>
        </Row>

        <FormItem {...formItemLayout} label="期望价格：">
          <InputGroup>
            <Col span="12">
              <NumberInput placeholder="最低" addonAfter="万元" {...fields.minimumPriceWan} />
            </Col>
            <Col span="12">
              <NumberInput placeholder="最高"i addonAfter="万元" {...fields.maximumPriceWan} />
            </Col>
          </InputGroup>
        </FormItem>

        <FormItem {...formItemLayout} label="上牌年月：">
          <Datepicker {...fields.licensedAt} format="month" />
        </FormItem>
      </div>
    )
  }

  render() {
    const { fields, readOnlyChannel } = this.props

    return (
      <AForm>
        <FormItem {...formItemLayout} label="客户姓名：">
          <InputGroup>
            <Col span="12">
              <Input {...fields.customerName} />
            </Col>
            <Col span="12">
              <RadioGroup {...fields.gender}>
                <Radio key="a" value="male">男</Radio>
                <Radio key="b" value="female">女</Radio>
              </RadioGroup>
            </Col>
          </InputGroup>
        </FormItem>

        <Row>
          <Col span="12">
            <FormItem {...firstColLayout} label="联系电话：" required field={fields.customerPhone}>
              <Input {...fields.customerPhone} />
            </FormItem>
          </Col>
          <Col span="12" pull="1">
            {readOnlyChannel ?
              <FormItem {...secondColLayout} label="客户来源：">
                {readOnlyChannel.name}
              </FormItem> :
              <FormItem {...secondColLayout} label="客户来源：" required field={fields.channelId}>
                <ChannelSelect {...fields.channelId} />
              </FormItem>
            }
          </Col>
        </Row>

        <FormItem {...formItemLayout} label="归属地区：">
          <RegionSelectGroup>
            <InputGroup>
              <Col span="12">
                <ProvinceSelect {...fields.province} />
              </Col>
              <Col span="12">
                <CitySelect {...fields.city} />
              </Col>
            </InputGroup>
          </RegionSelectGroup>
        </FormItem>

        {this.renderSeekIntentionForm()}

        {this.renderSaleIntentionForm()}

        <FormItem {...formItemLayout} label="备注：">
          <Textarea rows={4} {...fields.intentionNote} className="ant-input ant-input-lg" />
        </FormItem>
      </AForm>
    )
  }
}
