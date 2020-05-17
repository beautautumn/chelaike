import React, { PropTypes } from 'react'
import values from 'lodash/values'
import { Select } from 'antd'

const { Option } = Select

export default function MultiRoleSelect(props) {
  const { roles, value, onChange } = props

  return (
    <Select
      multiple
      value={value}
      onChange={onChange}
    >
      {values(roles).map(role => (
        <Option key={role.id} value={role.id}>{role.name}</Option>
      ))}
    </Select>
  )
}

MultiRoleSelect.propTypes = {
  roles: PropTypes.array.isRequired,
  name: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.arrayOf(PropTypes.number),
}
