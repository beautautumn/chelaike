import React, { Component, PropTypes } from 'react'
import { fetchOne as fetchCompany, update } from 'redux/modules/companies'
import { fetch as fetchOss, shouldFetch } from 'redux/modules/oss'
import { show as showNotification } from 'redux/modules/notification'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Form from './Form/Form'
import { connectData } from 'decorators'
import { Segment } from 'components'
import Helmet from 'react-helmet'

function fetchData(getState, dispatch) {
  return dispatch(fetchCompany())
}

@connectData(fetchData)
@connect(
  (state) => ({
    company: state.companies.currentCompany,
    saved: state.companies.saved,
    saving: state.companies.saving,
    oss: state.oss,
  }),
  dispatch => ({
    ...bindActionCreators({
      update,
      fetchOss,
      showNotification,
    }, dispatch)
  })
)
export default class EditPage extends Component {
  static propTypes = {
    history: PropTypes.object.isRequired,
    oss: PropTypes.object.isRequired,
    company: PropTypes.object,
    update: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    fetchOss: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool
  }

  componentDidMount() {
    const { oss, fetchOss } = this.props
    if (shouldFetch(oss)) {
      fetchOss()
    }
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.saved && nextProps.saved) {
      this.props.showNotification({
        type: 'success',
        message: '保存成功',
      })
    }
  }

  handleSubmit = (data) => {
    this.props.update(data)
  }

  render() {
    const { company, oss, saving } = this.props

    return (
      <div>
        <Helmet title="公司信息" />
        <h2 className="ui header">公司信息</h2>

        <Segment className="ui grid segment">
          <Form
            initialValues={company}
            onSubmit={this.handleSubmit}
            oss={oss}
            saving={saving}
          />
        </Segment>
      </div>
    )
  }
}
