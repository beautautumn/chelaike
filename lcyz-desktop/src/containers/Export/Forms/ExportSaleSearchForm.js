import SearchForm from './SearchForm'
import { reduxForm } from 'redux-form'
import { connect } from 'react-redux'
import { mapSearchFormStateToProps, mapSearchFormDispatchToProps } from 'helpers/export'

@connect(mapSearchFormStateToProps, mapSearchFormDispatchToProps)
@reduxForm({
  form: 'exportSaleSearchForm',
  fields: [
    'carShopCityEq',
    'carShopIdEq',
    'carOwnerCompanyIdEq',
    'carSellerIdEq',
    'createdAtGteq',
    'createdAtLteq'
  ]
})
export default class ExportSaleSearchForm extends SearchForm {

  componentWillMount() {
    this.initData()
  }

  shouldRenderCompanyField() {
    return true
  }

  searchFields() {
    const { fields } = this.props
    return {
      city: fields.carShopCityEq,
      shop: fields.carShopIdEq,
      company: fields.carOwnerCompanyIdEq,
      user: {
        label: '业务员',
        field: fields.carSellerIdEq
      },
      date: {
        label: '成交日期',
        gteq: fields.createdAtGteq,
        lteq: fields.createdAtLteq
      }
    }
  }
}
