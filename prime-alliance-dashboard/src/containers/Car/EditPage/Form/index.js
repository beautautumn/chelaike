import React, { Component, PropTypes } from 'react'
import { reduxForm } from 'redux-form'
import { bindActionCreators } from 'multireducer'
import { Form as AForm, Button, Affix } from 'antd'
import Style from 'models/style'
import { applyStyleDetail, autoFillExpirationDates } from 'models/form/car'
import Waypoint from 'react-waypoint'
import * as forms from './forms'
import get from 'lodash/get'
import set from 'lodash/set'
import uniq from 'lodash/uniq'
import validation from './validation'
import styles from '../style.scss'

const fields = uniq(Object.keys(forms).reduce((acc, key) =>
  [...acc, ...forms[key].fields], ['car.id']
))

function mapStateToProps(state) {
  return {
    enumValues: state.enumValue,
    styleDetailFetched: state.style.detailFetched,
    features: state.style.features,
    recommendedPrice: state.style.recommendedPrice,
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    applyStyleDetail,
    autoFillExpirationDates,
  }, dispatch, 'inStock')
}

@reduxForm({
  form: 'car',
  fields,
  validate: validation,
}, mapStateToProps, mapDispatchToProps)
export default class Form extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    car: PropTypes.object.isRequired,
    fields: PropTypes.object.isRequired,
    values: PropTypes.object.isRequired,
    pristine: PropTypes.bool.isRequired,
    tab: PropTypes.string,
    markSubformStatus: PropTypes.func.isRequired,
    markActivedTab: PropTypes.func.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    handleCancel: PropTypes.func.isRequired,
    applyStyleDetail: PropTypes.func.isRequired,
    autoFillExpirationDates: PropTypes.func.isRequired,
    styleDetailFetched: PropTypes.bool,
    features: PropTypes.array,
    recommendedPrice: PropTypes.object,
    enumValues: PropTypes.object.isRequired,
    useableTabs: PropTypes.array,
  }

  componentWillReceiveProps(nextProps) {
    const { dispatch } = this.props
    this.checkFormStatus(nextProps)

    // 收购
    if (this.props.values.car.styleName !== nextProps.values.car.styleName &&
      !nextProps.pristine) {
      dispatch(Style.fetchDetail(nextProps.values.car.seriesName, nextProps.values.car.styleName))
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
    const formStatus = Object.keys(forms).reduce((status, form) => {
      for (const fieldName of forms[form].fields) {
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
    <Waypoint
      key="waypoint"
      onEnter={(event) => this.onWayPointChange(preHref, 'enter', event)}
      onLeave={(event) => this.onWayPointChange(href, 'leave', event)}
      threshold={-0.03}
      scrollableAncestor={window}
    />
  )

  render() {
    const { car, fields, handleSubmit, handleCancel } = this.props
    const formNames = Object.keys(forms)
    const fieldsGroup = formNames.reduce((acc, key) => {
      acc[key] = forms[key].fields.reduce((group, field) => {
        set(group, field, get(fields, field))
        return group
      }, {})
      return acc
    }, {})

    return (
      <AForm horizontal>
        {this.isUseable('acquisition') && [
          this.renderScrollSpy('acquisition'),
          <forms.Acquisition key="acquisition" car={car} fields={fieldsGroup.Acquisition} />,
        ]}
        {this.isUseable('basic') && [
          this.renderScrollSpy('basic', 'acquisition'),
          <forms.Basic key="basic" fields={fieldsGroup.Basic} />,
        ]}
        {this.isUseable('price') && [
          this.renderScrollSpy('price', 'basic'),
          <forms.Price key="price" fields={fieldsGroup.Price} />,
        ]}
        {this.isUseable('description') && [
          this.renderScrollSpy('description', 'price'),
          <forms.Description key="description" fields={fieldsGroup.Description} />,

        ]}
        {this.isUseable('sales') && [
          this.renderScrollSpy('sales', 'description'),
          <forms.Sales key="sales" car={car} fields={fieldsGroup.Sales} />,
        ]}
        {this.isUseable('images') && [
          this.renderScrollSpy('images', 'sales'),
          <forms.Images key="images" fields={fieldsGroup.Images} />,
        ]}
        {this.isUseable('maintaining') && [
          this.renderScrollSpy('maintaining', 'images'),
          <forms.Maintaining key="maintaining" fields={fieldsGroup.Maintaining} />,
        ]}
        {this.isUseable('features') && [
          this.renderScrollSpy('features', 'maintaining'),
          <forms.Features key="features" fields={fieldsGroup.Features} />,
        ]}
        <Affix offsetBottom={30}>
          <div className={styles.bottomBar}>
            <Button size="large" onClick={handleCancel}>返回</Button>
            <Button type="primary" size="large" onClick={handleSubmit}>保存</Button>
          </div>
        </Affix>
      </AForm>
    )
  }
}
