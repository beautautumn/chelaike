import { createSelector } from 'reselect'
import moment from 'moment'

const carSelect = (state, id) => state.entities.cars && state.entities.cars[id]
const transfersSelect = (state) => state.entities.transfers
const currentUserSelect = (state) => state.auth.user

export const editDefaultValues = createSelector(
  carSelect,
  transfersSelect,
  currentUserSelect,
  (car, transfersById, currentUser) => {
    if (car) {
      const acquisitionTransfer = transfersById[car.acquisitionTransfer]
      return {
        car: {
          ...car,
          imagesAttributes: car.images,
          cooperationCompanyRelationshipsAttributes: car.cooperationCompanyRelationships,
          attachments: car.attachments || []
        },
        acquisitionTransfer: {
          ...acquisitionTransfer,
          imagesAttributes: acquisitionTransfer.images
        },
        publishers: {
          che168: car.che168PublishRecord || {}
        }
      }
    }

    return {
      car: {
        shopId: currentUser.shopId,
        acquisitionType: 'acquisition',
        acquirerId: currentUser.id,
        acquiredAt: moment().format('YYYY-MM-DD'),
        cooperationCompanyRelationships: [
          { cooperationCompanyId: '', cooperationPriceWan: '' }
        ],
        state: 'in_hall',
        fuelType: 'gasoline',
        emissionStandard: 'guo_4',
        licenseInfo: 'licensed',
        starRating: 5,
        allowedMortgage: true,
        manufacturerConfiguration: [],
        attachments: []
      }
    }
  }
)

export const carStateValues = createSelector(
  carSelect,
  (car) => {
    if (car) {
      return {
        state: car.state,
        sellable: car.sellable,
        occurredAt: moment().format('YYYY-MM-DD'),
        note: car.stateNote
      }
    }
    return {}
  }
)
