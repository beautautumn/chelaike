import styles from './SearchForm.scss'
import React, { Component, PropTypes } from 'react'
import { Row, Col, Form as AForm, Button } from 'antd'
import { Segment, Select, Datepicker, FormItem } from 'components'

export default class SearchForm extends Component {

  static propTypes = {
    fields: PropTypes.object.isRequired,
    values: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    resetForm: PropTypes.func.isRequired,
    onReset: PropTypes.func.isRequired,
    onExport: PropTypes.func.isRequired
  }

  initData() {
    const { fetchCities, fetchShops, fetchCompanies, fetchUsers } = this.props
    fetchCities()
    fetchShops('')
    if (this.shouldRenderCompanyField()) {
      fetchCompanies('')
    }
    fetchUsers('')
  }

  handleReset = () => {
    const { resetForm, onReset } = this.props
    resetForm()
    onReset()
  }

  handleExport = () => {
    const { onExport, values } = this.props
    onExport(values)
  }

  handleCityChange = (value) => {
    this.searchFields().city.onChange(value)
    this.handleShopChange('')

    this.props.fetchShops(value)
  }

  handleShopChange = (value) => {
    const searchFields = this.searchFields()
    searchFields.shop.onChange(value)

    if (this.shouldRenderCompanyField()) {
      searchFields.company.onChange('')
      this.props.fetchCompanies(value)
    }

    searchFields.user.field.onChange('')
    this.props.fetchUsers(value)
  }

  renderCompanyField() {
    const { companies } = this.props
    const { company } = this.searchFields()
    return (
      <Col span="8">
        <FormItem label="所属车商" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
          <Select
            items={companies}
            emptyText="不限"
            {...company}
          />
        </FormItem>
      </Col>
    )
  }

  renderUserField() {
    const { users } = this.props
    const { user } = this.searchFields()
    return (
      <Col span="8">
        <FormItem label={user.label} labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
          <Select
            items={users}
            emptyText="不限"
            {...user.field}
          />
        </FormItem>
      </Col>
    )
  }

  render() {
    const searchFields = this.searchFields()
    const { cities, shops, handleSubmit } = this.props
    return (
      <Segment>
        <AForm>
          <Row>
            <Col span="8">
              <FormItem label="城市" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <Select
                  {...searchFields.city}
                  items={cities}
                  emptyText="不限"
                  onChange={this.handleCityChange}
                />
              </FormItem>
            </Col>
            <Col span="8">
              <FormItem label="门店" labelCol={{ span: 6 }} wrapperCol={{ span: 14 }}>
                <Select
                  {...searchFields.shop}
                  items={shops}
                  emptyText="不限"
                  onChange={this.handleShopChange}
                />
              </FormItem>
            </Col>
            {this.shouldRenderCompanyField() ? this.renderCompanyField() : this.renderUserField()}
          </Row>
          <Row>
            {this.shouldRenderCompanyField() ? this.renderUserField() : null}
            <Col span="12">
              <FormItem label={searchFields.date.label} labelCol={{ span: 4 }}>
                <Col span="5">
                  <Datepicker {...searchFields.date.gteq} />
                </Col>
                <Col span="1">
                  <p className="ant-form-split">-</p>
                </Col>
                <Col span="5">
                  <Datepicker {...searchFields.date.lteq} />
                </Col>
                <Col span="9" className={styles.buttonPanel}>
                  <Button type="primary" htmlType="submit" onClick={handleSubmit}>搜索</Button>
                  <Button onClick={this.handleReset}>清空</Button>
                  <Button onClick={this.handleExport}>导出</Button>
                </Col>
              </FormItem>
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
