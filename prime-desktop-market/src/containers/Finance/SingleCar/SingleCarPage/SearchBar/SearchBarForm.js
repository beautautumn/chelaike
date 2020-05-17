import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { shallowEqual } from 'react-pure-render'
import { Form as AForm, Row, Col, Input, } from 'antd'
import {
  Segment, BrandSelectGroup, ShopSelect, BrandSelect, SeriesSelect,
  Select, Datepicker, UserSelect, SearchBarActions
} from 'components'
import styles from 'containers/CarSearchBar/CarSearchBar.scss'
import map from 'lodash/map'

@reduxForm({
  form: 'costAndBenefitOfCarsSearch',
  fields: [
    'carNameOrCarStockNumberOrCarVinOrCarCurrentPlateNumberCont',
    'carShopIdEq', 'carBrandNameEq', 'carSeriesNameEq',
    'carAcquirerIdEq', 'carAcquisitionTypeIn', 'carAcquiredAtGteq', 'carAcquiredAtLteq',
    'carStockOutInventorySellerIdEq', 'carStockOutInventorySalesTypeEq',
    'carStockOutAtGteq', 'carStockOutAtLteq'
  ]
})
export default class SearchBarForm extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    values: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    resetForm: PropTypes.func.isRequired,
    enumValues: PropTypes.object.isRequired,
  }

  componentDidUpdate(prevProps) {
    if (!shallowEqual(this.props.values, prevProps.values)) {
      this.props.handleSubmit()
    }
  }

  render() {
    const { fields, resetForm, enumValues } = this.props

    return (
      <Segment>
        <AForm>
          <Row>
            <Col span="12">
              <Input
                placeholder="输入车辆名称／库存号／车架号／车牌号等，搜索结果实时显示"
                {...fields.carNameOrCarStockNumberOrCarVinOrCarCurrentPlateNumberCont}
              />
            </Col>
            <Col span="3" offset="9">
              <SearchBarActions handleClear={resetForm} />
            </Col>
          </Row>
          <Row className={styles.row}>
            <Col>
              <table className={styles.table}>
                <tbody>
                  <BrandSelectGroup as="all">
                    <tr>
                      <td className={styles.label}>
                        基本信息
                      </td>
                      <td className={styles.input}>
                        <Input.Group>
                          <Col span="6">
                            <ShopSelect
                              {...fields.carShopIdEq}
                              size="default"
                              prompt="分店"
                              emptyText="不限分店"
                            />
                          </Col>
                          <Col span="6">
                            <BrandSelect
                              {...fields.carBrandNameEq}
                              size="default"
                              prompt="品牌"
                              emptyText="不限品牌"
                            />
                          </Col>
                          <Col span="6">
                            <SeriesSelect
                              {...fields.carSeriesNameEq}
                              size="default"
                              prompt="车系"
                              emptyText="不限车系"
                            />
                          </Col>
                        </Input.Group>
                      </td>
                    </tr>
                  </BrandSelectGroup>
                  <tr>
                    <td className={styles.label}>
                      收购信息
                    </td>
                    <td className={styles.input}>
                      <Input.Group>
                        <Col span="6">
                          <UserSelect
                            {...fields.carAcquirerIdEq}
                            size="default"
                            prompt="收购员"
                            emptyText="不限收购员"
                            as="all"
                          />
                        </Col>
                        <Col span="6">
                          <Select
                            multiple
                            size="default"
                            prompt="收购类型"
                            items={
                              map(
                                enumValues.car.acquisition_type,
                                (text, value) => ({ value, text })
                              )
                            }
                            {...fields.carAcquisitionTypeIn}
                            value={
                              fields.carAcquisitionTypeIn.value ?
                                fields.carAcquisitionTypeIn.value : []
                            }
                          />
                        </Col>
                        <Col className={styles.hasSplit} span="4">
                          <Datepicker
                            {...fields.carAcquiredAtGteq}
                            size="default"
                            placeholder="收购日期"
                          />
                        </Col>
                        <Col span="1">
                          <p className="ant-form-split">到</p>
                        </Col>
                        <Col span="4">
                          <Datepicker
                            {...fields.carAcquiredAtLteq}
                            size="default"
                            placeholder="收购日期"
                          />
                        </Col>
                      </Input.Group>
                    </td>
                  </tr>
                  <tr>
                    <td className={styles.label}>
                      出库信息
                    </td>
                    <td className={styles.input}>
                      <Input.Group>
                        <Col span="6">
                          <UserSelect
                            {...fields.carStockOutInventorySellerIdEq}
                            size="default"
                            prompt="选择销售员"
                            emptyText="不限销售员"
                            as="all"
                          />
                        </Col>
                        <Col span="6">
                          <Select
                            {...fields.carStockOutInventorySalesTypeEq}
                            size="default"
                            prompt="选择销售类型"
                            items={enumValues.stock_out_inventory.sales_type}
                            emptyText="不限销售类型"
                          />
                        </Col>
                        <Col className={styles.hasSplit} span="4">
                          <Datepicker
                            {...fields.carStockOutAtGteq}
                            size="default"
                            placeholder="选择出库日期"
                          />
                        </Col>
                        <Col span="1">
                          <p className="ant-form-split">到</p>
                        </Col>
                        <Col span="4">
                          <Datepicker
                            {...fields.carStockOutAtLteq}
                            size="default"
                            placeholder="选择出库日期"
                          />
                        </Col>
                      </Input.Group>
                    </td>
                  </tr>
                </tbody>
              </table>
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
