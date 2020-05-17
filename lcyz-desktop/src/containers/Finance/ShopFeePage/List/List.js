import React from 'react'
import { Table } from 'antd'
import { Segment, InlineEdit } from 'components'
import styles from './List.scss'

export default function List({ shopFees, handleChange, handleSubmit }) {
  const columns = [
    {
      key: 'month',
      dataIndex: 'month',
      title: '年月',
      width: 80,
      fixed: 'left',
    },
    {
      key: 'carCostWan',
      dataIndex: 'carCostWan',
      title: (
        <div>
          <div>车辆成本</div>
          <div>（万元）</div>
        </div>
      ),
      render(text) { return text === '-' ? text : text.toFixed(4) }
    },
    {
      key: 'operationCost',
      title: '运营费用',
      children: [
        {
          key: 'locationRentYuan',
          dataIndex: 'locationRentYuan',
          title: (
            <div>
              <div>场租</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'locationRentYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'salaryYuan',
          dataIndex: 'salaryYuan',
          title: (
            <div>
              <div>固定工资</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'salaryYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'socialInsuranceYuan',
          dataIndex: 'socialInsuranceYuan',
          title: (
            <div>
              <div>社保／公积金</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'socialInsuranceYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'bonusYuan',
          dataIndex: 'bonusYuan',
          title: (
            <div>
              <div>奖金／福利</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'bonusYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'marketingExpensesYuan',
          dataIndex: 'marketingExpensesYuan',
          title: (
            <div>
              <div>市场营销</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'marketingExpensesYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'energyFeeYuan',
          dataIndex: 'energyFeeYuan',
          title: (
            <div>
              <div>水电</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'energyFeeYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'officeFeeYuan',
          dataIndex: 'officeFeeYuan',
          title: (
            <div>
              <div>办公用品</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'officeFeeYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'communicationFeeYuan',
          dataIndex: 'communicationFeeYuan',
          title: (
            <div>
              <div>通讯费</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'communicationFeeYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
        {
          key: 'otherCostYuan',
          dataIndex: 'otherCostYuan',
          title: (
            <div>
              <div>其它</div>
              <div>（元）</div>
            </div>
          ),
          render: (text, record) => (
            <InlineEdit
              value={text}
              onChange={handleChange(record.id, 'otherCostYuan')}
              onEnter={handleSubmit(record.id)}
              onBlur={handleSubmit(record.id)}
            />
          ),
        },
      ]
    },
    {
      key: 'salesRevenueWan',
      dataIndex: 'salesRevenueWan',
      title: (
        <div>
          <div>销售收入</div>
          <div>（万元）</div>
        </div>
      ),
      render(text) { return text === '-' ? text : text.toFixed(4) }
    },
    {
      key: 'otherProfitYuan',
      dataIndex: 'otherProfitYuan',
      title: (
        <div>
          <div>其它收入</div>
          <div>（元）</div>
        </div>
      ),
      render: (text, record) => (
        <InlineEdit
          value={text}
          onChange={handleChange(record.id, 'otherProfitYuan')}
          onEnter={handleSubmit(record.id)}
          onBlur={handleSubmit(record.id)}
        />
      ),
    },
    {
      key: 'gross',
      title: '利润',
      children: [
        {
          key: 'grossProfit',
          dataIndex: 'grossProfit',
          title: (
            <div>
              <div>毛利</div>
              <div>（万元）</div>
            </div>
          ),
          render(text) { return text === '-' ? text : text.toFixed(4) }
        },
        {
          key: 'grossMargin',
          dataIndex: 'grossMargin',
          title: '毛利率',
          render(text) { return text === '-' ? text : text.toFixed(2) + ' %' }
        },
        {
          key: 'netProfit',
          dataIndex: 'netProfit',
          title: (
            <div>
              <div>经营净利</div>
              <div>（万元）</div>
            </div>
          ),
          render(text) { return text === '-' ? text : text.toFixed(4) }
        },
        {
          key: 'netMargin',
          dataIndex: 'netMargin',
          title: '经营净利率',
          render(text) { return text === '-' ? text : text.toFixed(2) + ' %' }
        },
      ]
    },
    {
      key: 'note',
      title: '备注',
      width: 200,
    },
  ]

  return (
    <Segment>
      <Table
        className={styles.costAndIncomeTable}
        columns={columns}
        dataSource={shopFees}
        bordered
        scroll={{ x: 1600 }}
        pagination={{ pageSize: 6 }}
      />
    </Segment>
  )
}
