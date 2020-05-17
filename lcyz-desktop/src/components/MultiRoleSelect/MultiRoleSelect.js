import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { setAuthorities } from 'redux/modules/form/user'
import find from 'lodash/find'
import uniq from 'lodash/uniq'
import values from 'lodash/values'
import { Select } from 'antd'

const { Option } = Select

@connect(
  null,
  dispatch => ({
    ...bindActionCreators({ setAuthorities }, dispatch)
  })
)
export default
class MultiRoleSelect extends Component {
  static propTypes = {
    roles: PropTypes.array.isRequired,
    name: PropTypes.string,
    onChange: PropTypes.func.isRequired,
    defaultValue: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.arrayOf(PropTypes.number),
    ]),
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.arrayOf(PropTypes.number),
    ]),
    setAuthorities: PropTypes.func.isRequired
  }

  handleChange = (value) => {
    this.props.setAuthorities(this.selectedAuthorities(value))
    this.props.onChange(value)
  }


  selectedAuthorities(rolesId) {
    let authorities = []
    rolesId.forEach((roleId) => {
      const role = find(this.props.roles, (r) => r.id === roleId) // eslint-disable-line id-length
      authorities = uniq(authorities.concat(role.authorities))
    })
    return authorities
  }

  render() {
    const { roles } = this.props

    return (
      <Select
        multiple
        {...this.props}
        onChange={this.handleChange}
      >
        {values(roles).map(role => (
          <Option key={role.id} value={role.id}>{role.name}</Option>
        ))}
      </Select>
    )
  }
}
