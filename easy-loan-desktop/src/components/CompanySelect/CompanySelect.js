import React from 'react'
import { Select, Spin } from 'antd'
import find from 'lodash/find'
import debounce from 'lodash.debounce'
import callApi from '../../models/services/callApi'
const Option = Select.Option

class CompanySelect extends React.Component {

  constructor(props) {
    super(props)
    this.lastFetchId = 0
    this.fetchCompanies = debounce(this.fetchCompanies, 50)
  }

  state = {
    data: [],
    value: [],
    fetching: false,
  }

  fetchCompanies = (value) => {
    this.lastFetchId += 1
    const fetchId = this.lastFetchId
    this.setState({ fetching: true })
    callApi('/shops', {
      query: { shopName: value }
    }).then(({ response }) => {
      if (fetchId !== this.lastFetchId) return
      const data = response.data.map(c => ({
        id: c.id,
        name: c.name,
        address: c.address,
        contactName: c.contact_user_name,
        contactPhone: c.phone
      }))
      this.setState({ data })
    })
  }

  handleChange = (valueWithLabel) => {
    const value = { ...valueWithLabel }
    if (valueWithLabel.label) {
      const { onChange, afterChanged } = this.props
      onChange(value.key)
      afterChanged(find(this.state.data, {id: +value.key}))
      value.key = valueWithLabel.label
    }
    this.setState({
      value,
      data: [],
      fetching: false,
    })
  }

  render() {
    const { fetching, data, value } = this.state
    return (
      <Select
        mode="combobox"
        labelInValue
        value={value}
        placeholder={this.props.placeholder}
        notFoundContent={fetching ? <Spin size="small" /> : null}
        filterOption={false}
        onSearch={this.fetchCompanies}
        onChange={this.handleChange}
        optionLabelProp="name"
      >
        {data.map(d => <Option key={d.id} name={d.name}>{d.name}</Option>)}
      </Select>
    );
  }
}

export default CompanySelect