import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import { reset } from 'redux-form'
import Notification from 'models/notification'
import Intention from 'models/intention/intention'
import EnumValue from 'models/enumValue'
import { PushHistoryModal, EditModal, AssignModal, PushModal } from '..'
import SearchBar from './SearchBar'
import ToolBar from './ToolBar'
import List from './List'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'config/constants'
import qs from 'qs'
import Auth from 'models/auth'
import { decamelizeKeys } from 'humps'
import config from 'config'

const sortableFields = [
  { key: 'id', name: '创建时间' },
  { key: 'due_time', name: '下次跟进时间' },
]

const defaultQuery = {
  query: {},
  orderField: 'id',
  orderBy: 'desc',
  perPage: PAGE_SIZE,
  page: 1,
}

@connect(
  _state => ({
    intentions: Intention.select('list'),
    selectedIds: Intention.getState().selectedIds,
    total: Intention.getState().total,
    query: Intention.getState().query,
    enumValues: EnumValue.getState(),
    currentUser: Auth.getState().user,
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    intentions: PropTypes.array.isRequired,
    selectedIds: PropTypes.array.isRequired,
    total: PropTypes.number.isRequired,
    query: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    currentUser: PropTypes.object.isRequired,
  }

  componentWillMount() {
    const { dispatch, query } = this.props
    dispatch(Intention.fetch({ ...defaultQuery, ...query }))
  }

  handleSort = (sort) => () => {
    const { dispatch, query } = this.props
    dispatch(Intention.fetch({ ...query, ...sort }))
  }

  handleSearch = data => {
    const { dispatch, query } = this.props
    dispatch(Intention.fetch({ ...query, ...{ query: data } }))
  }

  handleSearchReset = () => {
    const { dispatch } = this.props
    dispatch(reset('intentionSearch'))
    dispatch(Intention.fetch({ ...defaultQuery }))
  }

  handlePage = page => {
    const { dispatch, query } = this.props
    dispatch(Intention.fetch({ ...query, page }))
  }

  handleMoreHistory = id => event => {
    event.preventDefault()
    const { dispatch } = this.props
    dispatch(showModal('pushHistory', { id }))
  }

  handleNew = () => {
    const { dispatch } = this.props
    dispatch(showModal('intentionEdit', { type: 'seek' }))
  }

  handleBatchAssign = () => {
    const { dispatch, selectedIds } = this.props
    if (selectedIds.length === 0) {
      dispatch(Notification.show({
        type: 'warn',
        message: '请先选择意向',
      }))
    } else {
      dispatch(showModal('intentionAssign', { ids: selectedIds }))
    }
  }

  handleEdit = id => event => {
    event.preventDefault()
    const { dispatch } = this.props
    dispatch(showModal('intentionEdit', { id }))
  }

  handlePush = id => event => {
    event.preventDefault()
    const { dispatch } = this.props
    dispatch(showModal('intentionPush', { id }))
  }

  handleDestroy = id => () => {
    const { dispatch } = this.props
    dispatch(Intention.destroy(id))
  }

  handleSelectChange = ids => {
    const { dispatch } = this.props
    dispatch(Intention.check(ids))
  }

  handleExport = () => {
    const { query, currentUser } = this.props
    let queryObj = {
      AutobotsToken: currentUser.token,
    }
    if (query) {
      queryObj = {
        ...queryObj,
        ...decamelizeKeys(query),
      }
    }
    const queryString = qs.stringify(queryObj, { arrayFormat: 'brackets' })

    return `${config.serverUrl}${config.basePath}/intentions/export?${queryString}`
  }

  render() {
    const { intentions, total, query, enumValues } = this.props

    return (
      <div>
        <Helmet title="客户跟踪" />

        <PushHistoryModal />
        <EditModal />
        <AssignModal />
        <PushModal />

        <SearchBar
          enumValues={enumValues}
          handleSearch={this.handleSearch}
          handleSearchReset={this.handleSearchReset}
        />

        <ToolBar
          total={total}
          fields={sortableFields}
          query={query}
          handleSort={this.handleSort}
          handleNew={this.handleNew}
          handleBatchAssign={this.handleBatchAssign}
          handleExport={this.handleExport}
        />

        <List
          intentions={intentions}
          total={total}
          query={query}
          enumValues={enumValues}
          handlePage={this.handlePage}
          handleMoreHistory={this.handleMoreHistory}
          handleDestroy={this.handleDestroy}
          handleSelectChange={this.handleSelectChange}
          handleEdit={this.handleEdit}
          handlePush={this.handlePush}
        />
      </div>
    )
  }
}
