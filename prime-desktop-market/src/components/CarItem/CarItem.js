import React, { PropTypes } from 'react'
import { PureComponent } from 'react-pure-render'
import { CarImage } from 'components'
import { price } from 'helpers/car'
import styles from './CarItem.scss'

export default class CarItem extends PureComponent {
  static propTypes = {
    car: PropTypes.object.isRequired
  }

  render() {
    const { car } = this.props

    return (
      <div className="item">
        <div className={styles.car}>
          <div className={styles.carImage}>
            <CarImage car={car} width={80} height={50} />
          </div>
          <div className={styles.carInfo}>
            <div className={styles.carName}>
              <a href={`/cars/${car.id}`} target="_blank">{car.systemName}</a>
            </div>
            <div className={styles.carPrice}>
              {price(car.showPriceWan, '万')}
            </div>
          </div>
        </div>
      </div>
    )
  }
}
