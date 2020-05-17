import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { goBack } from 'react-router-redux'
import { fetchOne as fetchUser, create, update } from 'redux/modules/users'
import { fetch as fetchRoles } from 'redux/modules/roles'
import { fetchOne as fetchCompany } from 'redux/modules/companies'
import { fetch as fetchAuthorities } from 'redux/modules/authorities'
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
  if (!getState().authorities.authorities) {
    promises.push(dispatch(fetchAuthorities()))
  }
  return Promise.all(promises)
}

const viewAuthories = []

@connectData(fetchData)
@connect(
  state => ({
    usersById: state.entities.users,
    shopsById: state.entities.shops,
    companiesById: state.entities.companies,
    currentUser: state.auth.user,
    roles: visibleEntitiesSelector('roles')(state),
    currentCompany: state.companies.currentCompany,
    saved: state.users.saved,
    saving: state.users.saving,
    authorities: state.authorities.authorities,
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
      window.top.postMessage('success', '*')
    }
  }

  filterAuthorities = () => {
    if (viewAuthories.length > 0) return
    const { currentUser, authorities } = this.props
    if (!authorities) return
    if (!currentUser) return
    const group = authorities[currentUser.userType]
    if (!group) return
    Object.keys(group).forEach(key => {
      const category = {
        category: key,
        authorities: Object.keys(group[key]).map(key => ({ name: key }))
      }
      viewAuthories.push(category)
    })
  }

  convertToAuthories = (viewItem) => {
    const { authorities, currentUser } = this.props
    const group = authorities[currentUser.userType]
    const ret = []
    if (group) {
      Object.keys(group).forEach(key => {
        Object.keys(group[key]).forEach(k => {
          if (viewItem && viewItem.includes(k)) {
            ret.push(...Object.keys(group[key][k]))
          }
        })
      })
    }
    ret.push(...Object.keys(authorities.hidden))
    return ret
  }

  convertToViewItems = (auths) => {
    const { authorities, currentUser } = this.props
    const group = authorities[currentUser.userType]
    if (!group) return []
    const ret = []
    Object.keys(group).forEach(key => {
      Object.keys(group[key]).forEach(ke => {
        if (Object.keys(group[key][ke]).every(ele => auths.includes(ele))) {
          ret.push(ke)
        }
      })
    })
    return ret
  }

  handleSubmit = (data) => {
    if (this.props.saving) {
      return
    }
    data.authorities = this.convertToAuthories(data.viewItems)
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
    const { currentUser, usersById, shopsById, companiesById, roles, params } = this.props
    this.filterAuthorities()
    let user

    if (params.id) {
      user = usersById[params.id]
      user.managerId = user.manager
      user.authorityRoleIds = user.authorityRoles
      user.shopName = user.shopId && shopsById[user.shopId].name
      user.companyName = user.companyId && companiesById[user.companyId].name
    } else {
      user = {
        userType: currentUser.userType,
        companyId: currentUser.companyId,
        companyName: currentUser.company ? currentUser.company.name : '',
        state: 'enabled',
        isAllianceContact: false,
        authorityType: 'role',
        authorityRoleIds: [],
        settings: {
          crossShopRead: true,
          crossShopEdit: true,
          macAddressLock: false,
          deviceNumberLock: false,
        }
      }
    }

    return (
      <Form
        initialValues={user}
        onSubmit={this.handleSubmit}
        currentUser={currentUser}
        roles={roles}
        handleCancel={this.handleCancel}
        authorities={viewAuthories}
        convertToViewItems={this.convertToViewItems}
      />
    )
  }
}
