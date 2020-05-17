import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/serviceAppointments'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'
import { Table, Pagination } from 'antd'
import date from 'helpers/date'
import styles from '../../../Intention/FollowingPage/List/List.scss'

@connect(
  state => ({
    appointments: visibleEntitiesSelector('serviceAppointments')(state),
    fetchParams: state.serviceAppointments.fetchParams,
    end: state.serviceAppointments.end,
    total: state.serviceAppointments.total,
    fetching: state.serviceAppointments.fetching,
    enumValues: state.enumValues,
  }),
  { fetch }
)
export default class List extends Component {
  static propTypes = {
    appointments: PropTypes.array.isRequired,
    fetchParams: PropTypes.object.isRequired,
    fetching: PropTypes.bool,
    end: PropTypes.bool,
    total: PropTypes.number.isRequired,
    enumValues: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetch({ orderBy: 'desc', orderField: 'id', perPage: PAGE_SIZE }, true)
  }

  handlePage = (page) => {
    const { fetchParams, fetch } = this.props
    fetch({ ...fetchParams, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  render() {
    const { enumValues, fetchParams, total, appointments } = this.props

    const columns = [
      {
        key: 'customerName',
        dataIndex: 'customerName',
        title: '客户名称',
        width: 160,
      },
      {
        key: 'customerPhone',
        dataIndex: 'customerPhone',
        title: '客户电话',
        width: 160,
      },
      {
        key: 'serviceAppointmentType',
        dataIndex: 'serviceAppointmentType',
        title: '服务类型',
        width: 160,
        render: text => enumValues.service_appointment.service_appointment_type[text]
      },
      {
        key: 'note',
        dataIndex: 'note',
        title: '特殊说明',
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: '预约日期',
        width: 160,
        render: text => date(text)
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
        <Helmet title="服务预约" />
        <div className="clearfix">
          <Pagination {...paginationProps} className={styles.pagination} />
        </div>
        <Table
          rowKey={car => car.id}
          columns={columns}
          dataSource={appointments}
          bordered
          pagination={paginationProps}
        />
      </Segment>
    )
  }
}
