import React, { Component, PropTypes } from 'react'
import { Row, Col, Input } from 'antd'
import { NumberInput } from '@prime/components'
import { FormItem, RegionSelectGroup, ProvinceSelect, CitySelect, Datepicker } from 'components'
import { formOptimize } from 'decorators'
import styles from '../../EditModal.scss'

const fields = [
  'currentLocationProvince',
  'currentLocationCity',
  'newPlateNumber',
  'newOwner',
  'newOwnerIdcard',
  'newOwnerContactMobile',
  'estimatedArchivedAt',
  'estimatedTransferredAt',
  'transferFeeYuan',
]

@formOptimize(fields)
class NewInfo extends Component {
  static propTypes = {
    formItemLayout: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
  }

  render() {
    const { formItemLayout, fields } = this.props

    return (
      <div className={styles.formPanel}>
        <div className={styles.formPanelTitle}>新车主过户信息</div>

        <RegionSelectGroup>
          <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 19 }} label="车辆现属地：">
            <Input.Group>
              <Col span="11">
                <ProvinceSelect {...fields.currentLocationProvince} style={{ width: '170px' }} />
              </Col>
              <Col span="12" offset="1">
                <CitySelect {...fields.currentLocationCity} style={{ width: '170px' }} />
              </Col>
            </Input.Group>
          </FormItem>
        </RegionSelectGroup>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="新车牌号：">
              <Input {...fields.newPlateNumber} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="新车主姓名：">
              <Input {...fields.newOwner} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="新车主证件号：">
              <Input {...fields.newOwnerIdcard} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem
              {...formItemLayout}
              label="新车主联系方式："
              field={fields.newOwnerContactMobile}
            >
              <Input {...fields.newOwnerContactMobile} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="提档预计完成：">
              <Datepicker {...fields.estimatedArchivedAt} />
            </FormItem>
          </Col>
          <Col span="12">
            <FormItem {...formItemLayout} label="落户预计完成：">
              <Datepicker {...fields.estimatedTransferredAt} />
            </FormItem>
          </Col>
        </Row>

        <Row>
          <Col span="12">
            <FormItem {...formItemLayout} label="过户费用：">
              <NumberInput addonAfter="元" {...fields.transferFeeYuan} />
            </FormItem>
          </Col>
        </Row>
      </div>
    )
  }
}

NewInfo.fields = fields

export default NewInfo

