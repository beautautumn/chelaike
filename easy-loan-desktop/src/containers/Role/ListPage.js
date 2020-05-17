import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { fetch, create, update, setVisible } from 'models/reducers/role'
import entitiesSelector from '../../utils/entitiesSelector'
import { RoleTable, RoleModal } from '../../components'
import pick from 'lodash/pick'

class ListPage extends React.Component {

  componentDidMount() {
    this.props.fetch()
  }

  showModal = (record) => {
    this.form.resetFields()
    if (record) {
      this.form.setFieldsValue(
        pick(record, ['id', 'authorities', 'name', 'note'])
      )
    }
    this.props.setVisible(true)
  }

  handleCancel = () => {
    this.props.setVisible(false)
  }

  handleOk = () => {
    this.form.validateFields((err, values) => {
      if (err) return
      if (values.id) {
        this.props.update(values)
      } else {
        this.props.create(values)
      }
    })
  }

  saveFormRef = form => this.form = form

  render() {
    const {
      roles, authorities,
      loading, confirmLoading, visible,
    } = this.props
    return (
      <div>
        <RoleTable
          showModal={this.showModal}
          loading={loading}
          data={roles} />
        <RoleModal
          ref={this.saveFormRef}
          onOk={this.handleOk}
          onCancel={this.handleCancel}
          confirmLoading={confirmLoading}
          authorities={authorities}
          visible={visible} />
      </div>
    )
  }
}

ListPage.propTypes = {
  roles: PropTypes.array.isRequired,
  fetch: PropTypes.func.isRequired,
  create: PropTypes.func.isRequired,
  update: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  visible: PropTypes.bool.isRequired,
  confirmLoading: PropTypes.bool.isRequired,
  authorities: PropTypes.array.isRequired,
}

export default connect(
  state => ({
    roles: entitiesSelector('roles')(state),
    loading: state.roles.loading,
    confirmLoading: state.roles.confirmLoading,
    visible: state.roles.visible,
    authorities: state.profile.authorities,
  }),
  { fetch, create, update, setVisible }
)(ListPage)
