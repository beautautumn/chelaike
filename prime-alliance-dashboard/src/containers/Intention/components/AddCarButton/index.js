import React, { PropTypes } from 'react'
import { Button } from 'antd'
import { ListModal as CarListModal } from 'containers/Car'

export default function AddCarButton(props) {
  const { type, value, onChange, handleAdd } = props

  return (
    <div>
      <CarListModal
        type={type}
        handleSelect={onChange}
        selectedIds={value}
      />
      <Button type="primary" onClick={handleAdd}>添加预约车辆</Button>
    </div>
  )
}

AddCarButton.propTypes = {
  value: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  handleAdd: PropTypes.func.isRequired,
  type: PropTypes.string,
}
