import React, { Component, PropTypes } from 'react'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination } from 'antd'
import date from 'helpers/date'
import styles from './List.scss'

export default class List extends Component {
  static propTypes = {
    maintenanceRecords: PropTypes.array.isRequired,
    fetchParams: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    total: PropTypes.number.isRequired,
    fetch: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetch({ perPage: PAGE_SIZE, page: 1 }, true)
  }

  handlePage = (page) => {
    const { fetchParams, fetch } = this.props
    fetch({ ...fetchParams, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  render() {
    const { fetchParams, total, maintenanceRecords } = this.props

    const columns = [
      {
        key: 'vin',
        dataIndex: 'vin',
        title: '车架号',
        width: 120,
      },
      {
        key: 'carName',
        dataIndex: 'carName',
        title: '车型',
        width: 160,
      },
      {
        key: 'userName',
        dataIndex: 'userName',
        title: '查询人',
        width: 80,
      },
      {
        key: 'fetchAt',
        dataIndex: 'fetchAt',
        title: '查询时间',
        width: 80,
        render: text => date(text)
      },
      {
        key: 'platform',
        dataIndex: 'platform',
        title: '查询平台',
        width: 80,
      },
      {
        key: 'tokenPrice',
        dataIndex: 'tokenPrice',
        title: '车币',
        width: 80,
      },
      {
        key: 'stored',
        dataIndex: 'stored',
        title: '车辆状态',
        width: 120,
        render: (stored, record) => {
          if (stored) {
            return (
              <div>
                <span>已入库</span>
                {record.carId &&
                  <span>，</span>
                }
                {record.carId &&
                  <span>
                    <a href={`/cars/${record.carId}`} target="_blank">查看车辆详情</a>
                  </span>
                }
              </div>
            )
          }
          return '未入库'
        }
      }
    ]

    const paginationProps = {
      pageSize: PAGE_SIZE,
      current: +fetchParams.page,
      total,
      onChange: this.handlePage
    }

    return (
      <Segment>
        <Helmet title="维保纪录统计" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          rowKey={record => record.id}
          columns={columns}
          dataSource={maintenanceRecords}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
