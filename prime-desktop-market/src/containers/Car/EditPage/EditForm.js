import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { bindActionCreators } from 'redux-polymorphic'
import { Form } from 'antd'
import * as Forms from './Forms'
import uniq from 'lodash/uniq'
import validation from './validation'
import get from 'lodash/get'
import set from 'lodash/set'
import Waypoint from 'react-waypoint'
import { fetchDetail } from 'redux/modules/styles'
import { applyStyleDetail, autoFillExpirationDates } from 'redux/modules/form/car'
import can from 'helpers/can'

const ScrollSpy = ({ href, preHref, onWayPointChange }) => (
  <Waypoint
    onEnter={(event) => onWayPointChange(preHref, 'enter', event)}
    onLeave={(event) => onWayPointChange(href, 'leave', event)}
    threshold={-0.03}
    scrollableAncestor={window}
  />
)

const fields = uniq(Object.keys(Forms).reduce((acc, key) =>
  [...acc, ...Forms[key].fields], ['car.id']
))

function mapStateToProps(state) {
  return {
    enumValues: state.enumValues,
    styleDetailFetched: state.styles.detailFetched,
    features: state.styles.features,
    recommendedPrice: state.styles.recommendedPrice,
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchDetail,
    applyStyleDetail,
    autoFillExpirationDates
  }, dispatch, 'inStock')
}

@reduxForm({
  form: 'car',
  fields,
  validate: validation
}, mapStateToProps, mapDispatchToProps)
export default class EditForm extends Component {
  static propTypes = {
    tab: PropTypes.string,
    markSubformStatus: PropTypes.func.isRequired,
    markActivedTab: PropTypes.func.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    handleCancel: PropTypes.func.isRequired,
    fetchDetail: PropTypes.func.isRequired,
    applyStyleDetail: PropTypes.func.isRequired,
    autoFillExpirationDates: PropTypes.func.isRequired,
    styleDetailFetched: PropTypes.bool,
    features: PropTypes.array,
    recommendedPrice: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
    useableTabs: PropTypes.array,
    shopId: PropTypes.number.isRequired,
  }

  componentDidMount() {
    window.addEventListener('message', this.props.handleSubmit, false)
  }

  componentWillReceiveProps(nextProps) {
    this.checkFormStatus(nextProps)

    // 收购
    if (this.props.values.car.styleName !== nextProps.values.car.styleName &&
        !nextProps.pristine) {
      this.props.fetchDetail(nextProps.values.car.seriesName, nextProps.values.car.styleName)
    }

    if (!this.props.styleDetailFetched && nextProps.styleDetailFetched) {
      this.props.applyStyleDetail(this.props.enumValues,
                                  nextProps.features,
                                  nextProps.recommendedPrice)
    }

    if (this.props.values.car.licensedAt !== nextProps.values.car.licensedAt &&
        !nextProps.pristine) {
      this.props.autoFillExpirationDates(nextProps.values.car.licensedAt)
    }
  }

  componentWillUnmount() {
    window.removeEventListener('message', this.props.handleSubmit)
  }

  onWayPointChange = (href, action, event) => {
    if (action === 'leave' && event.currentPosition !== 'below') {
      this.props.markActivedTab(href)
    }
    if (action === 'enter' && event.currentPosition !== 'above') {
      this.props.markActivedTab(href)
    }
    if (href === 'features' && action === 'enter' && event.currentPosition !== 'below') {
      this.props.markActivedTab('publisher')
    }
  }

  checkFormStatus(nextProps) {
    const { fields, markSubformStatus } = nextProps
    const formStatus = Object.keys(Forms).reduce((status, form) => {
      for (const fieldName of Forms[form].fields) {
        const field = get(fields, fieldName)
        const { dirty, touched, invalid } = field
        if (dirty || (touched && invalid)) {
          status[form] = { dirty, invalid }
          return status
        }
        status[form] = { dirty: false, invalid: false }
      }
      return status
    }, {})

    markSubformStatus(formStatus)
  }

  isUseable(tab) {
    return !this.props.useableTabs || this.props.useableTabs.includes(tab)
  }

  renderScrollSpy = (href, preHref) => (
    <ScrollSpy
      key={`spy-${href}`}
      href={href}
      preHref={preHref}
      onWayPointChange={this.onWayPointChange}
    />
  )

  render() {
    const { fields, shopId, enumValues } = this.props
    const formNames = Object.keys(Forms)
    const fieldsGroup = formNames.reduce((acc, key) => {
      acc[key] = Forms[key].fields.reduce((group, field) => {
        set(group, field, get(fields, field))
        return group
      }, {})
      return acc
    }, {})

    return (
      <Form horizontal>
      {this.isUseable('acquisition') && [
        this.renderScrollSpy('acquisition'),
        <Forms.acquisition key="acquisition" fields={fieldsGroup.acquisition} />
      ]}
      {this.isUseable('basic') && [
        this.renderScrollSpy('basic', 'acquisition'),
        <Forms.basic key="basic" fields={fieldsGroup.basic} />
      ]}
      {this.isUseable('price') && can('车辆销售定价', null, shopId) && [
        this.renderScrollSpy('price', 'basic'),
        <Forms.price key="price" fields={fieldsGroup.price} />
      ]}
      {this.isUseable('description') && [
        this.renderScrollSpy('description', 'price'),
        <Forms.description
          key="description"
          fields={fieldsGroup.description}
          enumValues={enumValues}
        />

      ]}
      {this.isUseable('sales') && [
        this.renderScrollSpy('sales', 'description'),
        <Forms.sales key="sales" fields={fieldsGroup.sales} />
      ]}
      {this.isUseable('images') && [
        this.renderScrollSpy('images', 'sales'),
        <Forms.images key="images" fields={fieldsGroup.images} />
      ]}
      {this.isUseable('maintaining') && [
        this.renderScrollSpy('maintaining', 'images'),
        <Forms.maintaining key="maintaining" fields={fieldsGroup.maintaining} />
      ]}
      {this.isUseable('features') && [
        this.renderScrollSpy('features', 'maintaining'),
        <Forms.features key="features" fields={fieldsGroup.features} />
      ]}
      </Form>
    )
  }
}
