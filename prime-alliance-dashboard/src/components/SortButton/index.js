import React, { PropTypes } from 'react'
import { Button, Icon } from 'antd'

export default function SortButton({ field, query, onSort }) {
  const nextOrder = query.orderBy === 'asc' ? 'desc' : 'asc'

  const buttonProps = {
    size: 'large',
    onClick: onSort({ orderField: field.key, orderBy: nextOrder }),
  }
  let iconType
  if (query.orderField === field.key) {
    buttonProps.type = 'primary'
    iconType = query.orderBy === 'desc' ? 'arrow-down' : 'arrow-up'
  }
  // antd 子组件不允许 null 或 false
  return iconType ? (
    <Button {...buttonProps} >
      {field.name}
      <Icon type={iconType} />
    </Button>
  ) : (
    <Button {...buttonProps} >
      {field.name}
    </Button>
  )
}

SortButton.propTypes = {
  field: PropTypes.object.isRequired,
  query: PropTypes.object.isRequired,
  onSort: PropTypes.func.isRequired,
}
