import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { show as showModal } from 'redux-modal'
import Alliance from 'models/alliance'
import Company from 'models/company'
import Oss, { shouldFetch } from 'models/oss'
import EnumValue from 'models/enumValue'
import { connectData } from 'decorators'
import List from './List'
import Form from './Form'
import { EditModal } from '..'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch) {
  return dispatch(Alliance.fetch())
}

@connectData(fetchData)
@connect(
  _state => ({
    companies: Company.select('list'),
    alliance: Alliance.getState().alliance,
    oss: Oss.getState(),
    saving: Alliance.getState().saving,
    enumValues: EnumValue.getState(),
  })
)
export default class ListPage extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    oss: PropTypes.object.isRequired,
    enumValues: PropTypes.object.isRequired,
    companies: PropTypes.array.isRequired,
    alliance: PropTypes.object.isRequired,
    saving: PropTypes.bool.isRequired,
  }

  componentWillMount() {
    this.props.dispatch(Company.fetch())
  }

  componentDidMount() {
    const { dispatch, oss } = this.props
    if (shouldFetch(oss)) {
      dispatch(Oss.fetch())
    }
  }

  handleSubmit = data => {
    const { dispatch, saving } = this.props
    if (saving) return
    dispatch(Alliance.update(data))
  }

  handleEdit = id => event => {
    event.preventDefault()
    this.props.dispatch(showModal('companyEdit', { id }))
  }


  render() {
    const { companies, alliance, oss, saving, enumValues } = this.props

    return (
      <div>
        <Helmet title="联盟信息" />

        <Form
          initialValues={alliance}
          oss={oss}
          saving={saving}
          onSubmit={this.handleSubmit}
          enumValues={enumValues}
        />
        <List
          companies={companies}
          handleEdit={this.handleEdit}
        />
        <EditModal />
      </div>
    )
  }
}
