import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/warranties'
import { show as showNotification } from 'redux/modules/notification'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { EditModal } from '..'
import { Table, Popconfirm } from 'antd'
import date from 'helpers/date'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    warranties: visibleEntitiesSelector('warranties')(state),
    destroyed: state.warranties.destroyed
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
    warranties: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool,
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

  handleDestroy = warranty => () => {
    this.props.destroy(warranty.id)
  }

  handleNew = () => {
    this.props.showModal('warrantyEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('warrantyEdit', { id })
  }

  render() {
    const { warranties } = this.props
    const columns = [
      { title: '质保等级名称', dataIndex: 'name', key: 'name' },
      { title: '质保费用（元）', dataIndex: 'fee', key: 'fee' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      { title: '操作', key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除质保等级：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = warranties.map((warranty) => ({
      key: warranty.id,
      id: warranty.id,
      name: warranty.name,
      createdAt: date(warranty.createdAt),
      fee: warranty.fee
    }))

    return (
      <div>
        <Helmet title="质保等级" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew}>
              新增质保等级
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
