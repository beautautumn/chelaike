import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { shallowEqual } from 'react-pure-render'
import { Form as AForm, Row, Col } from 'antd'
import { Segment, Select, FormItem, UserSelect, SearchBarActions } from 'components'
import styles from './SearchBar.scss'
import moment from 'moment'

@reduxForm({
  form: 'statisticsMaintenanceRecordSearch',
  fields: ['fetchBy', 'year', 'month']
})
export default class SearchBarForm extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    values: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    resetForm: PropTypes.func.isRequired,
  }

  componentDidUpdate(prevProps) {
    if (!shallowEqual(this.props.values, prevProps.values)) {
      this.props.handleSubmit()
    }
  }

  handleYearChange = (year) => {
    if (!year) {
      this.props.fields.month.onChange('')
    }
    this.props.fields.year.onChange(year)
  }

  render() {
    const { fields, resetForm } = this.props

    const currentYear = moment().year()
    const years = []
    for (let i = 0; i <= currentYear - 2016; ++i) {
      const optionYear = (2016 + i).toString()
      years.push({ text: optionYear, value: optionYear })
    }

    const months = []
    if (fields.year.value) {
      for (let i = 0, len = 12; i < len; i++) {
        months.push({ value: i + 1, text: i + 1 })
      }
    }

    return (
      <Segment>
        <AForm>
          <Row>
            <Col span="9">
              <FormItem label="查询人" labelCol={{ span: 4 }} wrapperCol={{ span: 14 }}>
                <UserSelect emptyText="不限" {...fields.fetchBy} as="all" />
              </FormItem>
            </Col>
            <Col span="10">
              <FormItem label="查询时间" labelCol={{ span: 4 }}>
                <Col span="6">
                  <Select
                    items={years}
                    emptyText="不限"
                    value={fields.year.value}
                    onChange={this.handleYearChange}
                  />
                </Col>
                <Col span="2" className={styles.tailLabel}>年</Col>
                <Col span="6">
                  <Select
                    items={months}
                    emptyText="不限"
                    {...fields.month}
                  />
                </Col>
                <Col span="2" className={styles.tailLabel}>月</Col>
              </FormItem>
            </Col>
            <Col span="5">
              <SearchBarActions handleClear={resetForm} />
            </Col>
          </Row>
        </AForm>
      </Segment>
    )
  }
}
