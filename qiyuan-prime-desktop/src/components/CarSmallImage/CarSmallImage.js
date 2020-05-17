import React from 'react'
import { scale } from 'helpers/image'
import carSmallImage from './carSmall.png'

export default ({ car }) => {
  const coverUrl = car.coverUrl ? scale(car.coverUrl, '230x150') : carSmallImage

  return (
    <img role="presentation" className="attached" src={coverUrl} />
  )
}
