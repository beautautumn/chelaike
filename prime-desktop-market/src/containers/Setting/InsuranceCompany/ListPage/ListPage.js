import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/insuranceCompanies'
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
    insuranceCompanies: visibleEntitiesSelector('insuranceCompanies')(state),
    destroyed: state.insuranceCompanies.destroyed
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
    insuranceCompanies: PropTypes.array.isRequired,
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

  handleDestroy = insuranceCompany => () => {
    this.props.destroy(insuranceCompany.id)
  }

  handleNew = () => {
    this.props.showModal('insuranceCompanyEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('insuranceCompanyEdit', { id })
  }

  render() {
    const { insuranceCompanies } = this.props
    const columns = [
      { title: '公司名称', dataIndex: 'name', key: 'name' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      { title: '操作', key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除保险公司：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = insuranceCompanies.map((company) => ({
      key: company.id,
      id: company.id,
      name: company.name,
      createdAt: date(company.createdAt)
    }))

    return (
      <div>
        <Helmet title="保险公司" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew}>
              新增保险公司
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
