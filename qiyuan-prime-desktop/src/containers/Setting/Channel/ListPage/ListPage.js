import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/channels'
import { show as showNotification } from 'redux/modules/notification'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { EditModal } from '..'
import date from 'helpers/date'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    channels: visibleEntitiesSelector('channels')(state),
    destroyed: state.channels.destroyed
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      destroy,
      showNotification,
      showModal,
    }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    channels: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool,
    history: PropTypes.object
  }

  componentDidMount() {
    this.props.fetch()
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '删除成功',
      })
    }
  }

  handleDestroy = channel => () => {
    this.props.destroy(channel.id)
  }

  handleNew = () => {
    this.props.showModal('channelEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('channelEdit', { id })
  }

  render() {
    const { channels } = this.props
    const columns = [
      { title: '渠道名称', dataIndex: 'name', key: 'name' },
      { title: '备注', dataIndex: 'note', key: 'note' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除渠道：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
            {record.wechatQrcodeUrl &&
              <span className="ant-divider"></span>
            }
            {record.wechatQrcodeUrl &&
              <a href={record.wechatQrcodeUrl} target="_blank" >二维码</a>
            }
          </span>
        )
      }
    ]

    const data = channels.map((channel) => ({
      key: channel.id,
      id: channel.id,
      name: channel.name,
      createdAt: date(channel.createdAt),
      note: channel.note,
      wechatQrcodeUrl: channel.wechatQrcodeUrl,
    }))
    return (
      <div>
        <Helmet title="渠道管理" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew} >
              新增渠道
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
