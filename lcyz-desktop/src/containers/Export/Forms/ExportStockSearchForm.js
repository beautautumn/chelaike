import SearchForm from './SearchForm'
import { connect } from 'react-redux'
import { reduxForm } from 'redux-form'
import { mapSearchFormStateToProps, mapSearchFormDispatchToProps } from 'helpers/export'

@connect(mapSearchFormStateToProps, mapSearchFormDispatchToProps)
@reduxForm({
  form: 'exportStockSearchForm',
  fields: [
    'shopCityEq',
    'shopIdEq',
    'ownerCompanyIdEq',
    'acquirerIdEq',
    'createdAtGteq',
    'createdAtLteq'
  ]
})
export default class ExportStockSearchForm extends SearchForm {

  componentWillMount() {
    this.initData()
  }

  shouldRenderCompanyField() {
    return true
  }

  searchFields() {
    const { fields } = this.props
    return {
      city: fields.shopCityEq,
      shop: fields.shopIdEq,
      company: fields.ownerCompanyIdEq,
      user: {
        label: '车源负责人',
        field: fields.acquirerIdEq
      },
      date: {
        label: '入库日期',
        gteq: fields.createdAtGteq,
        lteq: fields.createdAtLteq
      }
    }
  }
}
