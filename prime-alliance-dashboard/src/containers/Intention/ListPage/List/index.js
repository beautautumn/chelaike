import React, { PropTypes } from 'react'
import { Table, Pagination, Popconfirm, Timeline } from 'antd'
import { AlignedList } from '@prime/components'
import { Segment, TimeAgo } from 'components'
import { PAGE_SIZE } from 'config/constants'
import compact from 'lodash/compact'
import { price } from 'helpers/car'
import get from 'lodash/get'
import styles from './style.scss'
import date from 'helpers/date'

const states = {
  pending: '创建',
  completed: '成交',
  failed: '战败',
  interviewed: '预约',
  invalid: '无效',
  processing: '跟进',
  reserved: '预定',
  cancel_reserved: '取消',
  hall_consignment: '厅寄',
  online_consignment: '网寄',
}

function budget(minimumPriceWan, maximumPriceWan) {
  return `${compact([
    minimumPriceWan,
    maximumPriceWan,
  ]).join('-')}万`
}

function getSaleInfo(intention) {
  const channel = intention.channel
  return [
    { label: '出售：', text: [intention.brandName, intention.seriesName].join(' ') },
    { label: '期望价格：', text: budget(intention.minimumPriceWan, intention.maximumPriceWan) },
    { label: '评估价格：', text: price(intention.estimatedPriceWan, '万') },
    { label: '客户来源：', text: channel && channel.name },
  ]
}

function getSeekInfo(intention) {
  const channel = intention.channel
  let car
  if (!intention.sourceCar) {
    car = intention.seekingCars.filter((car) => car.brandName || car.seriesName).map((car) => (
      [car.brandName, car.seriesName].join(' ')
    )).join('，')
  } else {
    const wdUrl = `http://wd.chelaike.com/#!/${intention.sourceCompany.id}/product/${intention.sourceCar.id}/`
    car = (
      <span>
        <a href={wdUrl} target="_blank">{intention.sourceCar.name}</a>
        ({intention.sourceCompany.name})
      </span>
    )
  }

  return [
    { label: '求购：', text: car },
    { label: '预算：', text: budget(intention.minimumPriceWan, intention.maximumPriceWan) },
    { label: '客户来源：', text: channel && channel.name },
  ]
}

function AssignInfo({ intention }) {
  const data = [
    { label: '归属车商：', text: get(intention, 'company.name') },
    { label: '归属员工：', text: get(intention, 'assignee.name') },
    { label: '录入人：', text: get(intention, 'creator.name') },
    { label: '分配日期：', text: date(intention.allianceAssignedAt) },
  ]
  return <AlignedList data={data} dashed textMaxWidth={100} />
}
AssignInfo.propTypes = {
  intention: PropTypes.object.isRequired,
}

function CustomerInfo({ intention }) {
  const level = intention.IntentionLevel
  const labelName = intention.customerName || intention.customerPhone
  const labelValue = level ? `${intention.customerPhone} (${level.name})` : intention.customerPhone

  const data = [{ label: labelName, text: labelValue }]
  if (intention.intentionType === 'seek') {
    data.push(...getSeekInfo(intention))
  } else {
    data.push(...getSaleInfo(intention))
  }
  return <AlignedList data={data} dashed textMaxWidth={100} />
}
CustomerInfo.propTypes = {
  intention: PropTypes.object.isRequired,
}

function IntentionInfo({ intention, enumValues }) {
  const data = [
    { label: '意向状态：', text: enumValues.intention.state[intention.allianceState] },
    { label: '最近预约：', text: date(intention.interviewedTime) },
    { label: '最近到店：', text: date(intention.inShopAt) },
    { label: '创建日期：', text: date(intention.createdAt) },
  ]
  return <AlignedList data={data} dashed textMaxWidth={100} />
}
IntentionInfo.propTypes = {
  intention: PropTypes.object.isRequired,
  enumValues: PropTypes.object.isRequired,
}

function LatestPushHistory({ intention }) {
  const intentionPushHistory = intention.latestIntentionPushHistory

  if (!intentionPushHistory) return null

  const executor = intentionPushHistory.executor

  const pushHistories = intention.intentionPushHistories

  return (
    <div className="ui left aligned list">
      <div className="item">
        最后操作：
        <TimeAgo date={intentionPushHistory.createdAt} />
      </div>
      <div className="item">
        跟进人：{executor && executor.name}
      </div>
      <div className="item">
        到店次数：{intention.checkedCount}
      </div>
      {pushHistories &&
        <div className={styles.histories}>
          <Timeline>
            {pushHistories.map(pushHistory => (
              <Timeline.Item key={pushHistory.id}>
                <p>
                  {pushHistory.executor && pushHistory.executor.name}
                  进行“{states[pushHistory.state]}”操作
                </p>
                {pushHistory.checkedCount &&
                  <p>
                    第{pushHistory.checkedCount}次到店
                  </p>
                }
                {pushHistory.closingCarName &&
                  <p>
                    成交车辆：{pushHistory.closingCarName}
                  </p>
                }
                {pushHistory.closingCar &&
                  <p>
                    成交车辆：{`${pushHistory.closingCar.name}
                    （${pushHistory.closingCar.stockNumber}）`}
                  </p>
                }
                {pushHistory.interviewedTime &&
                  <p>
                    下次预约时间：{date(pushHistory.interviewedTime)}
                  </p>
                }
                {pushHistory.processingTime &&
                  <p>
                    下次跟进时间：{date(pushHistory.processingTime)}
                  </p>
                }
                {pushHistory.note &&
                  <p>
                    跟进说明：{pushHistory.note}
                  </p>
                }
                <p>{date(pushHistory.createdAt, 'full')}</p>
              </Timeline.Item>
            ))}
          </Timeline>
        </div>
      }
    </div>
  )
}
LatestPushHistory.propTypes = {
  intention: PropTypes.object.isRequired,
  handleMoreHistory: PropTypes.func.isRequired,
}

export default function List(props) {
  const {
    intentions,
    query,
    total,
    handlePage,
    handleMoreHistory,
    handleDestroy,
    handleEdit,
    handlePush,
    handleSelectChange,
    enumValues,
  } = props

  const columns = [
    {
      title: '客户信息',
      key: 'customerInfo',
      width: '200px',
      render: (text, intention) => <CustomerInfo intention={intention} />,
    },
    {
      title: '意向状态',
      key: 'state',
      width: '170px',
      render: (text, intention) => <IntentionInfo enumValues={enumValues} intention={intention} />,
    },
    {
      title: '归属',
      key: 'assignee',
      width: '190px',
      render: (text, intention) => <AssignInfo intention={intention} />,
    },
    {
      title: '备注／预约说明',
      dataIndex: 'intentionNote',
      key: 'intentionNote',
      width: '120px',
    },
    {
      title: '跟进历史',
      key: 'history',
      render: (text, intention) => (
        <LatestPushHistory intention={intention} handleMoreHistory={handleMoreHistory} />
      ),
    },
    {
      title: '操作',
      key: 'operation',
      width: '60px',
      render: (text, intention) => (
        <span>
          <a href="#" onClick={handlePush(intention.id)}>跟进</a>
          <span className="ant-divider"></span>
          <a href="#" onClick={handleEdit(intention.id)}>编辑</a>
          <span className="ant-divider"></span>
          <Popconfirm
            title={`删除意向：${intention.customerName}`}
            onConfirm={handleDestroy(intention.id)}
          >
            <a href="#">删除</a>
          </Popconfirm>
        </span>
      ),
    },
  ]

  const paginationProps = {
    pageSize: PAGE_SIZE,
    current: +query.page,
    total,
    onChange: handlePage,
  }

  return (
    <Segment>
      <div className="clearfix">
        <Pagination {...paginationProps} className={styles.pagination} />
      </div>
      <Table
        rowSelection={{ onChange: handleSelectChange }}
        rowKey={intention => intention.id}
        columns={columns}
        dataSource={intentions}
        bordered
        pagination={paginationProps}
      />
    </Segment>
  )
}

List.propTypes = {
  intentions: PropTypes.array.isRequired,
  query: PropTypes.object.isRequired,
  total: PropTypes.number.isRequired,
  handlePage: PropTypes.func.isRequired,
  handleMoreHistory: PropTypes.func.isRequired,
  handleDestroy: PropTypes.func.isRequired,
  handleEdit: PropTypes.func.isRequired,
  handlePush: PropTypes.func.isRequired,
  handleSelectChange: PropTypes.func.isRequired,
  enumValues: PropTypes.object.isRequired,
}
