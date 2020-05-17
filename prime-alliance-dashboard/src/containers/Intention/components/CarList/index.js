import React, { PropTypes } from 'react'
import { Table } from 'antd'
import { CarImage } from 'components'
import { price } from 'helpers/car'

export default function CarList({ cars }) {
  const columns = [
    {
      key: 'cover',
      width: '100px',
      render: (text, car) => <CarImage width={100} height={60} car={car} url={car.coverUrl} />,
    },
    {
      key: 'info',
      render: (text, car) => (
        <div>
          <a href={`/cars/${car.id}`}>{car.name}</a>
          <br />
          所属车商：{car.company.name}
          <br />
          展厅价：{price(car.showPriceWan, '万')}
        </div>
      ),
    },

  ]

  if (cars.length === 0) {
    return null
  }

  return (
    <Table
      showHeader={false}
      rowKey={car => car.id}
      columns={columns}
      dataSource={cars}
      pagination={false}
    />
  )
}

CarList.propTypes = {
  cars: PropTypes.array.isRequired,
}
