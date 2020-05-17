import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/finance/singleCar'
import { visibleEntitiesSelector } from 'redux/selectors/entities'
import SearchBar from './SearchBar/SearchBar'
import ToolBar from './ToolBar/ToolBar'
import List from './List/List'
import InStockPriceModal from '../InStockPriceModal/InStockPriceModal'
import OutStockPriceModal from '../OutStockPriceModal/OutStockPriceModal'
import FundRateModal from '../FundRateModal/FundRateModal'
import CostAndBenefitModal from '../CostAndBenefitModal/CostAndBenefitModal'
import PaymentAndReceiptModal from '../PaymentAndReceiptModal/PaymentAndReceiptModal'
import { show as showModal } from 'redux-modal'

@connect(
  state => ({
    enumValues: state.enumValues,
    query: state.financeSingleCar.query,
    total: state.financeSingleCar.total,
    fetching: state.financeSingleCar.fetching,
    currentUser: state.auth.user,
    costAndBenefitOfCars: visibleEntitiesSelector('financeSingleCar')(state),
  }),
  { fetch, showModal }
)
export default class SingleCar extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    query: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    currentUser: PropTypes.object.isRequired,
    costAndBenefitOfCars: PropTypes.array.isRequired,
    fetching: PropTypes.bool,
    fetch: PropTypes.func.isRequired,
    showModal: PropTypes.func.isRequired,
  }

  render() {
    const {
      query, total, currentUser, enumValues,
      costAndBenefitOfCars, fetching, fetch, showModal,
    } = this.props

    return (
      <div>
        <SearchBar query={query} fetch={fetch} enumValues={enumValues} />
        <ToolBar query={query} total={total} fetch={fetch} currentUser={currentUser} />
        <List
          query={query}
          fetch={fetch}
          costAndBenefitOfCars={costAndBenefitOfCars}
          fetching={fetching}
          total={total}
          showModal={showModal}
          enumValues={enumValues}
        />
        <InStockPriceModal />
        <OutStockPriceModal />
        <FundRateModal />
        <CostAndBenefitModal />
        <PaymentAndReceiptModal />
      </div>
    )
  }
}
