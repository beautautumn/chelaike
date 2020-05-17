import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { goBack } from 'react-router-redux'
import { fetchOne as fetchUser, create, update } from 'redux/modules/users'
import { fetch as fetchRoles } from 'redux/modules/roles'
import { fetchOne as fetchCompany } from 'redux/modules/companies'
import { show as showNotification } from 'redux/modules/notification'
import Form from './Form/Form'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import { connectData } from 'decorators'

function fetchData(getState, dispatch, location, params) {
  const promises = [
    dispatch(fetchCompany()),
    dispatch(fetchRoles())
  ]
  if (params.id) {
    promises.push(dispatch(fetchUser(params.id)))
  }
  return Promise.all(promises)
}

@connectData(fetchData)
@connect(
  state => ({
    usersById: state.entities.users,
    roles: visibleEntitiesSelector('roles')(state),
    currentCompany: state.companies.currentCompany,
    saved: state.users.saved,
    saving: state.users.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      create,
      update,
      showNotification,
      goBack
    }, dispatch)
  })
)
export default class EditPage extends Component {
  static propTypes = {
    params: PropTypes.object.isRequired,
    usersById: PropTypes.object,
    currentCompany: PropTypes.object.isRequired,
    roles: PropTypes.array.isRequired,
    create: PropTypes.func.isRequired,
    update: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool,
    showNotification: PropTypes.func.isRequired,
    goBack: PropTypes.func.isRequired
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
      this.props.goBack()
    }
  }

  handleSubmit = (data) => {
    if (this.props.saving) {
      return
    }
    if (this.props.params && this.props.params.id) {
      this.props.update(data)
    } else {
      this.props.create(data)
    }
  }

  handleCancel = () => {
    this.props.goBack()
  }

  render() {
    const { currentCompany, usersById, roles, params } = this.props
    let user

    if (params.id) {
      user = usersById[params.id]
      user.managerId = user.manager
      user.authorityRoleIds = user.authorityRoles
    } else {
      user = {
        state: 'enabled',
        isAllianceContact: false,
        authorityType: 'role',
        authorityRoleIds: [],
        settings: {
          crossShopRead: false,
          crossShopEdit: false,
          macAddressLock: false,
          deviceNumberLock: false,
        }
      }
    }

    return (
      <Form
        initialValues={user}
        onSubmit={this.handleSubmit}
        currentCompany={currentCompany}
        roles={roles}
        handleCancel={this.handleCancel}
      />
    )
  }
}
