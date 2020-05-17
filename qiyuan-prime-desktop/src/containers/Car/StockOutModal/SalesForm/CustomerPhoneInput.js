import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { fetch } from 'redux/modules/intentions'
import { Select } from 'antd'
import debounce from 'lodash/debounce'

const { Option } = Select

@connect(
  state => ({
    intentions: visibleEntitiesSelector('intentions')(state, state.intentions.select.ids),
    intentionsById: state.entities.intentions
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch
    }, dispatch, 'select')
  })
)
export default class CustomerPhoneInput extends Component {
  static propTypes = {
    intentions: PropTypes.array.isRequired,
    intentionsById: PropTypes.object,
    fetch: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    onSelect: PropTypes.func.isRequired,
    defaultValue: PropTypes.string,
    value: PropTypes.string
  }

  handleChange = value => {
    if (this.props.intentionsById) {
      const intention = this.props.intentionsById[value]
      if (intention) {
        // It's a selection, stop here
        return this.props.onChange(intention.customerPhone)
      }
    }
    this.props.onChange(value)
    if (value && value !== '') {
      this.fetchIntentions(value)
    }
  }

  handleSelect = value => {
    const intention = this.props.intentionsById[value]
    this.props.onSelect(intention)
  }

  fetchIntentions = debounce(phone => {
    this.props.fetch('following', { query: { customerPhoneStart: phone } }, true)
  }, 200)

  renderOptions() {
    const { intentions } = this.props
    return intentions.map((intention) => (
      <Option key={intention.id}>{intention.customerName}({intention.customerPhone})</Option>
    ))
  }

  render() {
    const { defaultValue, value, onBlur } = this.props
    // filterOption 需要设置为 false，数据是动态设置的

    return (
      <Select
        combobox
        defaultValue={defaultValue}
        value={value}
        onChange={this.handleChange}
        onSelect={this.handleSelect}
        onBlur={onBlur}
        filterOption={false}
      >
        {this.renderOptions()}
      </Select>
    )
  }
}
