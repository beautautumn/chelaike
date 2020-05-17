import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { CarItem } from 'components'
import { SeekingCarsModal } from '..'
import { Button, Row, Col } from 'antd'

export default class SeekingCars extends PureComponent {
  static propTypes = {
    handleSeekingCarsEdit: PropTypes.func.isRequired,
    defaultValue: PropTypes.array,
    value: PropTypes.array,
    onChange: PropTypes.func.isRequired,
    carsById: PropTypes.object
  }

  handleSelect = ids => {
    this.props.onChange(ids)
  }

  renderCars() {
    const { carsById, value, defaultValue } = this.props
    const currentValue = value || defaultValue

    return currentValue.map((carId) => (
      <CarItem key={carId} car={carsById[carId]} />
    ))
  }

  render() {
    const { handleSeekingCarsEdit, value, defaultValue } = this.props
    const currentValue = value || defaultValue

    return (
      <Row>
        <Col offset="4" style={{ paddingBottom: '20px' }}>
          <SeekingCarsModal handleSelect={this.handleSelect} selectedIds={currentValue} />
          {this.renderCars()}
          <Button
            type="primary"
            onClick={handleSeekingCarsEdit}
          >
            添加看过的车辆
          </Button>
        </Col>
      </Row>
    )
  }
}
