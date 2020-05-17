import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { getRecoveryTime } from 'redux/modules/intentionRecoveryTime'
import { show as showModal } from 'redux-modal'
import { EditModal } from '..'
import date from 'helpers/date'
import { Table } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    recycle: state.intentionRecoveryTime.recycle,
  }),
  dispatch => ({
    ...bindActionCreators({
      getRecoveryTime,
      showModal,
    }, dispatch)
  })
)
export default class ListPage extends Component {
  componentDidMount() {
    this.props.getRecoveryTime()
  }

  handleEdit = (event) => {
    event.preventDefault()
    this.props.showModal('intentionRecoveryTimeEdit')
  }

  render() {
    const { recycle } = this.props
    const columns = [
      {
        title: '过期时间',
        dataIndex: 'recoveryTime',
        key: 'recoveryTime',
        render: text => (text ? `>= ${text} 天` : '不过期')
      },
      { title: '备注', dataIndex: 'note', key: 'note' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      {
        title: '操作',
        key: 'operation',
        render: () => (
          <span>
            <a href="#" onClick={this.handleEdit}>编辑</a>
          </span>
        )
      }
    ]

    const data = [{
      ...recycle,
      createdAt: date(recycle.createdAt)
    }]

    return (
      <div>
        <Helmet title="客户回收时间" />
        <EditModal />

        <Segment className="ui segment">
          <Table columns={columns} dataSource={data} bordered pagination={false} />
        </Segment>
      </div>
    )
  }
}
