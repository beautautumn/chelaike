import React, { Component, PropTypes } from 'react'
import { Row, Col, Input, Icon } from 'antd'
import styles from '../CarSearchBar.scss'

export default class Keyword extends Component {
  static propTypes = {
    query: PropTypes.object,
    advanced: PropTypes.bool,
    handleChange: PropTypes.func.isRequired,
    handleToggle: PropTypes.func.isRequired,
    handleClear: PropTypes.func.isRequired,
  }

  render() {
    const { query, advanced, handleChange, handleClear, handleToggle } = this.props

    return (
      <Row>
        <Col span="12">
          <Input
            placeholder="输入车辆名称／库存号／车架号／车牌号等，搜索结果实时显示"
            value={query.nameOrStockNumberOrVinOrCurrentPlateNumberCont}
            onChange={handleChange('nameOrStockNumberOrVinOrCurrentPlateNumberCont')}
          />
        </Col>
        <Col span="3" offset="9" className={styles.controller}>
          <a href="#" onClick={handleClear}>清空</a>
          <span className={styles.split}> | </span>
          {!advanced && (
            <a href="#" onClick={handleToggle}>更多<Icon type="down" /></a>
          )}
          {advanced && (
            <a href="#" onClick={handleToggle}>收起<Icon type="up" /></a>
          )}
        </Col>
      </Row>
    )
  }
}
