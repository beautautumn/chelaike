import SearchForm from './SearchForm'
import { reduxForm } from 'redux-form'
import { connect } from 'react-redux'
import { mapSearchFormStateToProps, mapSearchFormDispatchToProps } from 'helpers/export'

@connect(mapSearchFormStateToProps, mapSearchFormDispatchToProps)
@reduxForm({
  form: 'exportCustomerSearchForm',
  fields: [
    'shopCityEq',
    'shopIdEq',
    'assigneeIdEq',
    'createdAtGteq',
    'createdAtLteq'
  ]
})
export default class ExportCustomerSearchForm extends SearchForm {

  componentWillMount() {
    this.initData()
  }

  shouldRenderCompanyField() {
    return false
  }

  searchFields() {
    const { fields } = this.props
    return {
      city: fields.shopCityEq,
      shop: fields.shopIdEq,
      user: {
        label: '业务员',
        field: fields.assigneeIdEq
      },
      date: {
        label: '创建日期',
        gteq: fields.createdAtGteq,
        lteq: fields.createdAtLteq
      }
    }
  }
}
