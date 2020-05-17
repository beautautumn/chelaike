import React, { Component, PropTypes } from 'react'
import { Row, Col, Input, Radio } from 'antd'
import { RegionSelectGroup, ProvinceSelect, CitySelect, FormItem, RadioGroup } from 'components'
import { formOptimize } from 'decorators'
import styles from '../EditModal.scss'

const fields = [
  'originalLocationProvince',
  'originalLocationCity',
  'originalPlateNumber',
  'originalOwner',
  'originalOwnerIdcard',
  'originalOwnerContactMobile',
  'keyCount',
  'usageType',
  'registrationNumber',
  'engineNumber',
  'transferCount',
  'allowedPassengersCount',
]

@formOptimize(fields)
class CarInfo extends Component {
  static propTypes = {
    title: PropTypes.string.isRequired,
    enumValues: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { formItemLayout, title, enumValues, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>原车信息</div>
        <RegionSelectGroup>
          <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 19 }} label={title + '辆属地：'}>
            <Input.Group>
              <Col span="11">
                <ProvinceSelect {...fields.originalLocationProvince} style={{ width: '170px' }} />
              </Col>
              <Col span="12" offset="1">
                <CitySelect {...fields.originalLocationCity} style={{ width: '170px' }} />
              </Col>
            </Input.Group>
          </FormItem>
        </RegionSelectGroup>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label={title + '牌号：'}>
              <Input {...fields.originalPlateNumber} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label={title + '主姓名：'}>
              <Input {...fields.originalOwner} />
            </FormItem>
          </Col>
        </Row>

        {title === '原车' &&
          <Row>
            <Col span="12">
              <FormItem
                {...formItemLayout}
                label="原车主联系电话："
                field={fields.originalOwnerContactMobile}
              >
                <Input {...fields.originalOwnerContactMobile} />
              </FormItem>
            </Col>
            <Col span="12">
              <FormItem {...formItemLayout} label={title + '主证件号：'}>
                <Input {...fields.originalOwnerIdcard} />
              </FormItem>
            </Col>
          </Row>
        }
        {title !== '原车' &&
          <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 9 }} label={title + '主证件号：'}>
            <Input {...fields.originalOwnerIdcard} />
          </FormItem>
        }

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="钥匙数量：">
              <RadioGroup {...fields.keyCount}>
                <Radio value={1}>一把</Radio>
                <Radio value={2}>两把</Radio>
                <Radio value={3}>三把</Radio>
              </RadioGroup>
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="使用性质：">
              <RadioGroup {...fields.usageType}>
                {Object.keys(enumValues.transfer_record.usage_type).reduce((accumulator, key) => {
                  accumulator.push(
                    <Radio key={key} value={key}>
                      {enumValues.transfer_record.usage_type[key]}
                    </Radio>
                  )
                  return accumulator
                }, [])}
              </RadioGroup>
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="登记证书号：">
              <Input {...fields.registrationNumber} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="发动机号：">
              <Input {...fields.engineNumber} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="过户次数：">
              <Input {...fields.transferCount} addonAfter="次" />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="核定载客人数：">
              <Input {...fields.allowedPassengersCount} addonAfter="人" />
            </FormItem>
          </Col>
        </Row>
      </div>
    )
  }
}

CarInfo.fields = fields

export default CarInfo
