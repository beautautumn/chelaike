import React, { Component, PropTypes } from 'react'
import { Select } from 'components'

export default class CarCompanySelect extends Component {
  static propTypes = {
    onChange: PropTypes.func
  }

  static contextTypes = {
    companies: PropTypes.array,
    resetCompanies: PropTypes.bool,
  }

  componentDidUpdate() {
    if (this.context.resetCompanies) {
      this.props.onChange(null)
    }
  }

  render() {
    const companies = this.context.companies || []

    const items = companies.map((company) => (
      { value: company.id, text: company.name }
    ))

    return (
      <Select
        ref="select"
        items={items}
        prompt="选择归属车商"
        {...this.props}
      />
    )
  }
}
