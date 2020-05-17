import React from 'react'
import { Cascader } from 'antd'
import callApi from '../../models/services/callApi'

class RegionCascader extends React.Component {
  state = {
    options: []
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.value !== this.props.value) {
      this.loadCities(nextProps, this.state.options)
    }
  }

  componentDidMount() {
    callApi('/regions/provinces').then(({ response }) => {
      const options = response.data.map(v => ({
        value: v.name,
        label: v.name,
        isLeaf: false,
      }))
      this.loadCities(this.props, options)
      this.setState({ options })
    })
  }

  loadCities = (props, options) => {
    const value = props.value || props.defaultValue || ''
    const province = value.split(',')[0]
    if (!province) return
    for (let i = 0; i < options.length; ++i) {
      if (options[i].value === province && !options[i].children) {
        this.loadData([options[i]])
      }
    }
  }

  loadData = (selectedOptions) => {
    const targetOption = selectedOptions[selectedOptions.length - 1]
    targetOption.loading = true
    callApi('/regions/cities', {
      query: { province: { name: targetOption.label } }
    }).then(({ response }) => {
      targetOption.loading = false
      targetOption.children = response.data.map(v => ({
        value: v.name,
        label: v.name,
        isLeaf: true,
      }))
      this.setState({ options: [...this.state.options] })
    })
  }

  onChange = (value, selectedOptions) => {
    this.props.onChange(value.join(','))
  }
  render() {
    const props = this.props
    const value = props.value ? props.value.split(',') : null
    const defaultValue = props.defaultValue ? props.defaultValue.split(',') : null
    return (
      <Cascader
        {...props}
        value={value}
        defaultValue={defaultValue}
        options={this.state.options}
        loadData={this.loadData}
        onChange={this.onChange}
      />
    )
  }
}

export default RegionCascader
