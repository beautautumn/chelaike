import React, { PropTypes } from 'react'
import { Table, Input } from 'antd'
import { CarImage, FormItem } from 'components'
import { price } from 'helpers/car'

export default function List(props) {
  const {
    type,
    cars,
    selectedIds,
    handleSearch,
    handleSelect,
    handlePage,
    query,
    total,
  } = props

  const columns = [
    {
      key: 'cover',
      render: (text, car) => <CarImage width={100} height={60} car={car} url={car.coverUrl} />,
    },
    {
      key: 'info',
      render: (text, car) => (
        <div>
          <a href={`/cars/${car.id}`}>{car.name}</a>
          <br />
          所属车商：{`${car.company.name} （${car.stockNumber}）`}
          <br />
          展厅价：{price(car.showPriceWan, '万')}
          <br />
          网络价：{price(car.onlinePriceWan, '万')}
        </div>
      ),
    },
  ]

  const paginationProps = {
    pageSize: 5,
    current: +query.page,
    total,
    onChange: handlePage,
  }

  const keyword = query && query.query ?
    query.query.nameOrStockNumberOrVinOrCurrentPlateNumberCont : ''

  return (
    <div>
      <FormItem>
        <Input
          type="text"
          placeholder="搜索车辆名称／库存号／车架号／车牌号"
          onChange={handleSearch}
          value={keyword}
        />
      </FormItem>
      <Table
        rowSelection={{ type, selectedRowKeys: selectedIds, onChange: handleSelect }}
        showHeader={false}
        rowKey={car => car.id}
        columns={columns}
        dataSource={cars}
        bordered
        pagination={paginationProps}
      />
    </div>
  )
}

List.propTypes = {
  type: PropTypes.string.isRequired,
  cars: PropTypes.array.isRequired,
  selectedIds: PropTypes.array.isRequired,
  handleSearch: PropTypes.func.isRequired,
  handleSelect: PropTypes.func.isRequired,
  handlePage: PropTypes.func.isRequired,
  query: PropTypes.object.isRequired,
  total: PropTypes.number.isRequired,
}
