import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch, destroy } from 'redux/modules/roles'
import { show as showNotification } from 'redux/modules/notification'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import Item from './Item'
import { Link } from 'react-router'
import { Segment } from 'components'
import Helmet from 'react-helmet'

@connect(
  state => ({
    roles: visibleEntitiesSelector('roles')(state),
    destroyed: state.roles.destroyed
  }),
  dispatch => ({
    ...bindActionCreators({
      fetch,
      destroy,
      showNotification,
    }, dispatch)
  })
)

export default class ListPage extends Component {
  static propTypes = {
    roles: PropTypes.array.isRequired,
    fetch: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
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

  handleDestroy = role => () => {
    this.props.destroy(role.id)
  }

  render() {
    const {
      roles,
    } = this.props

    return (
      <div>
        <Helmet title="角色管理" />
        <h2 className="ui header">角色管理</h2>

        <div className="ui grid">
          <div className="ten wide column">
            <Link className="ui blue button" to="/roles/new">
              新增角色
            </Link>
          </div>
        </div>

        <Segment className="ui grid segment">
          <div className="sixteen wide column">
            <table className="ui celled selectable striped table center aligned">
              <thead>
                <tr>
                  <th>角色名称</th>
                  <th>备注</th>
                  <th>创建时间</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                {
                  roles.map((role) => (
                    <Item
                      key={role.id}
                      role={role}
                      handleDestroy={this.handleDestroy}
                    />
                  ))
                }
              </tbody>
            </table>
          </div>
        </Segment>
      </div>
    )
  }
}
