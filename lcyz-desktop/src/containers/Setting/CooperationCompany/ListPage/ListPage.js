import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/cooperationCompanies'
import { show as showNotification } from 'redux/modules/notification'
import { show as showModal } from 'redux-modal'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { EditModal } from '..'
import SearchForm from '../SearchForm/SearchForm'
import date from 'helpers/date'
import { Table, Popconfirm } from 'antd'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    cooperationCompanies: visibleEntitiesSelector('cooperationCompanies')(state),
    destroyed: state.cooperationCompanies.destroyed,
    total: state.cooperationCompanies.total,
    query: state.cooperationCompanies.query,
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
    cooperationCompanies: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
    destroyed: PropTypes.bool,
    query: PropTypes.object.isRequired,
    total: PropTypes.number,
  }

  componentDidMount() {
    this.props.fetch({ page: 1, perPage: 200 })
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '删除成功',
      })
    }
  }

  onSearch = (values = {}) => {
    this.props.fetch({
      page: 1, perPage: 200, query: { ...values }
    }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  onResetSearch = () => {
    this.onSearch()
  }

  handleDestroy = cooperationCompany => () => {
    this.props.destroy(cooperationCompany.id)
  }

  handleNew = () => {
    this.props.showModal('cooperationCompanyEdit')
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.showModal('cooperationCompanyEdit', { id })
  }

  handlePage = page => {
    const { query } = this.props
    this.props.fetch({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  render() {
    const { cooperationCompanies, query, total } = this.props
    const columns = [
      { title: '商家名称', dataIndex: 'name', key: 'name' },
      { title: '所属分店', dataIndex: 'shopName', key: 'shopName' },
      { title: '创建时间', dataIndex: 'createdAt', key: 'createdAt' },
      {
        title: '操作',
        key: 'operation',
        render: (text, record) => (
          <span>
            <a href="#" onClick={this.handleEdit(record.key)}>编辑</a>
            <span className="ant-divider"></span>
            <Popconfirm title={`删除合作商家：${record.name}`} onConfirm={this.handleDestroy(record)}>
              <a href="#">删除</a>
            </Popconfirm>
          </span>
        )
      }
    ]

    const data = cooperationCompanies.map((company) => ({
      key: company.id,
      id: company.id,
      name: company.name,
      shopName: company.shopName,
      createdAt: date(company.createdAt)
    }))

    const pagination = {
      pageSize: 200,
      current: +query.page,
      total,
      onChange: this.handlePage,
    }

    return (
      <div>
        <Helmet title="合作商家" />
        <EditModal />

        <div className="ui grid">
          <div className="ten wide column">
            <a className="ui blue button" onClick={this.handleNew}>
              新增合作商家
            </a>
          </div>
        </div>
        <SearchForm
          onSubmit={this.onSearch}
          onReset={this.onResetSearch}
        />
        <Segment className="ui segment">
          <Table columns={columns} dataSource={data} bordered pagination={pagination} />
        </Segment>
      </div>
    )
  }
}
