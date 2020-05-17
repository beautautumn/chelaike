import React, { Component } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/intentionLevels'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { EditModal } from '..'
import date from 'helpers/date'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    intentionLevels: visibleEntitiesSelector('intentionLevels')(state),
    destroyed: state.intentionLevels.destroyed
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      destroy,
      showModal,
    }, dispatch)
  })
)
export default class ListPage extends Component {
  componentDidMount() {
    this.props.fetch()
  }

  handleNew = () => {
    this.props.showModal('intentionLevelEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('intentionLevelEdit', { id })
  }

  handleDestroy = intentionLevel => () => {
    this.props.destroy(intentionLevel.id)
  }

  render() {
    const { intentionLevels } = this.props
    const columns = [
      { title: '客户等级', dataIndex: 'name', key: 'name' },
      {
        title: '最大跟进间隔天数',
        dataIndex: 'timeLimitation',
        key: 'timeLimitation',
        render: text => `${text}天`
      },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除客户等级：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = intentionLevels.map((level) => ({
      key: level.id,
      id: level.id,
      name: level.name,
      timeLimitation: level.timeLimitation,
      createdAt: date(level.createdAt)
    }))

    return (
      <div>
        <Helmet title="客户等级" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew}>
              新增客户等级
            </a>
          </div>
        </div>
        <Segment className="ui segment">
          <Table columns={columns} dataSource={data} bordered pagination={{ pageSize: 10 }} />
        </Segment>
      </div>
    )
  }
}
