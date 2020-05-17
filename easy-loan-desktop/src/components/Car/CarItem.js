import React from 'react'
import styles from './CarItem.scss'
import defaultCarImg from '../../../public/car.png'
import find from 'lodash/find'
import scale from '../../utils/scaleImage'
import config from '../../config'

const LoanImageLink = ({record, cate}) => {
  if (record && record[cate]) {
    const imgUrl = record[cate]
    if (imgUrl) {
      const cateNames = {
        'registrationLicense': '登记证',
        'drivingLicense': '行驶证',
        'insurance': '保单'
      }
      return (
        <a target="_blank" href={imgUrl}>{cateNames[cate]}</a>
      )
    }
  }
  return false
}
class CarItem extends React.Component {

  handleShowEvaluateModal = (car) => () => {
    this.props.showEvaluateModal(car)
  }

  render() {
    const { item, remarkImg } = this.props
    const corverImage = find(item.images, {isCover: true}) || item.images[0]
    return (
      <div className={`${styles.column} ${styles.car} ${styles.carItem}`}>
        <div className={styles.carImg}>
          {corverImage ?
            <img src={scale(corverImage.url, '320x240')} alt="" /> :
            <img src={defaultCarImg} alt="" />
          }
          {remarkImg ?
            <img src={remarkImg} className={styles.carImageMark} alt="" /> :
            null
          }
        </div>
        <div className={styles.carInfo}>
          <div>
            <a target="_blank" href={
              config.env === 'production' ?
              `http://${item.companyId}.site.chelaike.com/cars/${item.id}` :
              `http://tianche.lina-site.chelaike.com/cars/${item.id}`
              }>
              {`${item.brandName} ${item.seriesName} ${item.styleName}`}
            </a>
          </div>
          <div>车架号：{item.vin}</div>
          <div className={`${styles.row}`}>
            <div className={`${styles.col}`}>钥匙：{item.keysCount}把</div>
            <div className={`${styles.col} ${styles.alignRight}`}>
              {
                item.estimatePriceWan > 0 ?
                  ('估' + item.estimatePriceWan + '万/' + item.state) :
                  '未评估'
              }
            </div>
          </div>
        </div>
        <div className={styles.certificate}>
          <LoanImageLink record={item} cate="registrationLicense" />
          <LoanImageLink record={item} cate="drivingLicense" />
          <LoanImageLink record={item} cate="insurance" />
          <a onClick={this.handleShowEvaluateModal(item)}>评估</a>
        </div>
      </div>
    )
  }
}

export default CarItem