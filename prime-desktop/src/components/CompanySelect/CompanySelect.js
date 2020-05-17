import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class CompanySelect extends Component {
  static propTypes = {
    value: PropTypes.string,
    onChange: PropTypes.func,
    exclude: PropTypes.any,
  }

  static contextTypes = {
    companies: PropTypes.array,
    resetCompanies: PropTypes.bool,
    handleCompanyChange: PropTypes.func.isRequired,
  }

  componentDidMount() {
    const { value } = this.props
    // 如果有初始值
    if (value) {
      this.context.handleCompanyChange(value)
    }
  }

  componentWillReceiveProps(nextProps) {
    const { value } = this.props
    // 如果值有变化
    if (value !== nextProps.value && nextProps.value) {
      this.context.handleCompanyChange(nextProps.value)
    }
  }

  componentDidUpdate() {
    if (this.context.resetCompanies) {
      this.props.onChange('')
    }
  }

  onChange = (value) => {
    const { onChange } = this.props

    const companies = this.context.companies || []

    let company = companies.filter(item => (item.id.toString() === value))

    if (company.length > 0) {
      company = company[0]
    }
    onChange(value, company.name)
  }

  render() {
    const { exclude } = this.props

    const companies = this.context.companies || []
    const items = companies.filter(item => (!exclude || item.id !== exclude)).map(item => ({
      value: item.id.toString(),
      text: item.name
    }))

    return (
      <Select
        ref="select"
        items={items}
        {...this.props}
        onChange={this.onChange}
        prompt="选择联盟公司"
      />
    )
  }
}
