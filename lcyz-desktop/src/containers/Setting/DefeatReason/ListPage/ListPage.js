import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/defeatReasons'
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
    defeatReasons: visibleEntitiesSelector('defeatReasons')(state),
    destroyed: state.defeatReasons.destroyed
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
    defeatReasons: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool
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

  handleDestroy = defeatReason => () => {
    this.props.destroy(defeatReason.id)
  }

  handleNew = () => {
    this.props.showModal('defeatReasonEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('defeatReasonEdit', { id })
  }

  render() {
    const { defeatReasons } = this.props
    const columns = [
      { title: '战败原因', dataIndex: 'name', key: 'name' },
      { title: '备注', dataIndex: 'note', key: 'note' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      { title: '操作', key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除战败原因：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = defeatReasons.map((reason) => ({
      key: reason.id,
      id: reason.id,
      name: reason.name,
      note: reason.note,
      createdAt: date(reason.createdAt)
    }))

    return (
      <div>
        <Helmet title="战败原因" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew}>
              新增战败原因
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
