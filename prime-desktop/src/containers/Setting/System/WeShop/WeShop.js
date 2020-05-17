import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetchOne as fetchCompany, update } from 'redux/modules/companies'
import { fetch as fetchOss, shouldFetch } from 'redux/modules/oss'
import Form from './Form'
import { Segment } from 'components'

@connect(
  state => ({
    oss: state.oss,
    company: state.companies.currentCompany
  }),
  dispatch => ({
    ...bindActionCreators({
      fetchOss,
      fetchCompany,
      update
    }, dispatch)
  })
)
export default class WeShop extends Component {
  static propTypes = {
    oss: PropTypes.object,
    company: PropTypes.object,
    update: PropTypes.func.isRequired,
    fetchOss: PropTypes.func.isRequired,
    fetchCompany: PropTypes.func.isRequired
  }

  componentDidMount() {
    if (shouldFetch(this.props.oss)) {
      this.props.fetchOss()
    }
    this.props.fetchCompany()
  }

  handleSubmit = data => {
    this.props.update(data)
  }

  render() {
    const { oss, company } = this.props
    if (!company) { return null }

    const initialValues = company

    initialValues.banners = initialValues.banners || []

    return (
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3>微店设置</h3>
          <Form
            initialValues={initialValues}
            onSubmit={this.handleSubmit}
            oss={oss}
          />
        </div>
      </Segment>
    )
  }
}
