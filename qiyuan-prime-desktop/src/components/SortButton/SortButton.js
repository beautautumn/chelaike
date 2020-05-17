import React, { Component, PropTypes } from 'react'
import { Button, Icon } from 'antd'

export default class SortButton extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired,
    query: PropTypes.object.isRequired,
    onSort: PropTypes.func.isRequired
  }

  render() {
    const { field, query, onSort } = this.props
    const nextOrder = query.orderBy === 'asc' ? 'desc' : 'asc'

    const props = {
      size: 'large',
      onClick: onSort({ orderField: field.key, orderBy: nextOrder })
    }
    let iconType
    if (query.orderField === field.key) {
      props.type = 'primary'
      iconType = query.orderBy === 'desc' ? 'arrow-down' : 'arrow-up'
    }
    // antd 子组件不允许 null 或 false
    return iconType ? (
      <Button {...props} >
        {field.name}
        <Icon type={iconType} />
      </Button>
    ) : (
      <Button {...props} >
        {field.name}
      </Button>
    )
  }
}
