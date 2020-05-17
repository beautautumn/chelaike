import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { updateStockNumber, fetchOne as fetchCompany } from 'redux/modules/companies'
import { show as showNotification } from 'redux/modules/notification'
import Form from './Form'
import { Segment } from 'components'

@connect(
  state => ({
    company: state.companies.currentCompany,
    saved: state.companies.saved,
    saving: state.companies.saving
  }),
  dispatch => ({
    ...bindActionCreators({
      updateStockNumber,
      showNotification,
      fetchCompany,
    }, dispatch)
  })
)
export default class StockNumber extends Component {
  static propTypes = {
    company: PropTypes.object,
    updateStockNumber: PropTypes.func.isRequired,
    showNotification: PropTypes.func.isRequired,
    fetchCompany: PropTypes.func.isRequired,
    saving: PropTypes.bool.isRequired,
    saved: PropTypes.bool,
    history: PropTypes.object,
  }

  componentDidMount() {
    this.props.fetchCompany()
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
    if (!data.automatedStockNumberStart) {
      data.automatedStockNumberStart = 0
    }
    this.props.updateStockNumber(data)
  }

  render() {
    const { company, saving } = this.props

    if (!company) return null

    return (
      <Segment className="ui grid segment">
        <div className="sixteen wide column">
          <h3>库存号设置</h3>
          <Form
            initialValues={company.settings}
            company={company}
            onSubmit={this.handleSubmit}
            saving={saving}
          />
        </div>
      </Segment>
    )
  }
}
