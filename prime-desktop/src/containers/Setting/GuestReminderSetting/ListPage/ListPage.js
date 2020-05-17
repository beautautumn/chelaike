import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/expirationSettings'
import { show as showModal } from 'redux-modal'
import { EditModal } from '..'
import { Table } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'
import { visibleEntitiesSelector } from 'redux/selectors/entities'

@connect(
  state => ({
    expirationSettings: visibleEntitiesSelector('expirationSettings')(state),
  }),
  dispatch => (
    bindActionCreators({
      fetch,
      showModal,
    }, dispatch)
  )
)
export default class ListPage extends Component {
  componentDidMount() {
    this.props.fetch()
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('guestReminderEdit', { id })
  }

  render() {
    const { expirationSettings } = this.props

    const columns = [
      { title: '提醒类型', dataIndex: 'name', key: 'cate' },
      { title: '首次提醒时间', dataIndex: 'firstNotify', key: 'first' },
      { title: '再次提醒时间', dataIndex: 'secondNotify', key: 'second' },
      { title: '三次提醒时间', dataIndex: 'thirdNotify', key: 'third' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.id)}>编辑</a>
          </span>
        )
      }
    ]

    return (
      <div>
        <Helmet title="到期时间设置" />
        <EditModal />

        <Segment className="ui segment">
          <Table columns={columns} dataSource={expirationSettings} bordered pagination={false} />
        </Segment>
      </div>
    )
  }
}
