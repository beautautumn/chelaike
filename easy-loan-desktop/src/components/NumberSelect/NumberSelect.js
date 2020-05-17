import React from 'react'
import { Select } from 'antd'

// antd的select暂不支持数字类型的值，简单封装，避免太多的toString
class NumberSelect extends React.Component {
  render() {
    const { value, defaultValue, ...restProps } = this.props;
    const props = { ...restProps }
    if (value) props.value = value.toString()
    if (defaultValue) props.value = defaultValue.toString()
    return (
      <Select { ...props } />
    );
  }
}

export default NumberSelect
