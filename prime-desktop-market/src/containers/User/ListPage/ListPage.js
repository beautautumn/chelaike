import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, update, destroy } from 'redux/modules/users'
import { show as showNotification } from 'redux/modules/notification'
import { push } from 'react-router-redux'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import SearchBar from './SearchBar/SearchBar'
import { Button } from 'antd'
import List from './List/List'
import Helmet from 'react-helmet'
import { PAGE_SIZE } from 'constants'

const defaultQuery = {
  query: {},
  page: 1,
  perPage: PAGE_SIZE,
}

@connect(
  state => ({
    users: visibleEntitiesSelector('users')(state),
    usersById: state.entities.users,
    shopsById: state.entities.shops,
    rolesById: state.entities.roles,
    enumValues: state.enumValues,
    destroyed: state.users.destroyed,
    total: state.users.total,
    query: state.users.query,
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      update,
      destroy,
      showNotification,
      push
    }, dispatch)
  })
)
export default class ListPage extends Component {
  static propTypes = {
    users: PropTypes.array.isRequired,
    usersById: PropTypes.object,
    shopsById: PropTypes.object,
    rolesById: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
    fetch: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    current: PropTypes.number,
    push: PropTypes.func.isRequired,
    destroyed: PropTypes.bool
  }

  componentWillMount() {
    const { fetch, query } = this.props
    fetch({ ...defaultQuery, ...query })
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.destroyed && nextProps.destroyed) {
      this.props.showNotification({
        type: 'success',
        message: '删除成功',
      })
    }
  }

  handleDestroy = user => () => {
    this.props.destroy(user.id)
  }

  handleSwitch = user => event => {
    event.preventDefault()
    user.state = user.state === 'enabled' ? 'disabled' : 'enabled'
    this.props.update(user)
  }

  handleSearch = searchQuery => {
    const { query } = this.props
    this.props.fetch({ ...query, query: searchQuery })
  }

  handleSearchReset = () => {
    this.props.fetch(defaultQuery)
  }

  handleNew = () => {
    this.props.push('/users/new')
  }

  handlePage = page => {
    const { query } = this.props
    this.props.fetch({ ...query, page }).then(() => {
      window.scrollTo(0, 0)
    })
  }

  render() {
    const {
      users,
      enumValues,
      usersById,
      shopsById,
      rolesById,
      query,
      total,
    } = this.props

    return (
      <div>
        <Helmet title="员工管理" />
        <div style={{ marginBottom: 16 }}>
          <Button type="primary" size="large" onClick={this.handleNew}>新增员工</Button>
        </div>

        <SearchBar
          enumValues={enumValues}
          onSearch={this.handleSearch}
          onSearchReset={this.handleSearchReset}
        />

        <List
          total={total}
          query={query}
          users={users}
          usersById={usersById}
          shopsById={shopsById}
          rolesById={rolesById}
          handleSwitch={this.handleSwitch}
          handleDestroy={this.handleDestroy}
          handlePage={this.handlePage}
        />
      </div>
    )
  }
}
