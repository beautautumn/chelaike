import feeble from 'feeble'
import { takeEvery } from 'feeble/saga'
import { fork, put } from 'feeble/saga/effects'
import { hide } from 'redux-modal'
import { goBack } from 'react-router-redux'
import { crud, pagination, query } from './concerns'
import { PAGE_SIZE } from 'config/constants'
import Schemas from 'config/schemas'
import Notification from './notification'
import Entity from './entity'
import Auth from './auth'
import moment from 'moment'

const models = []

export default function factory(namespace) {
  if (models[namespace]) {
    return models[namespace]
  }

  const model = feeble.model({
    namespace,
    state: {
      ids: [],
      query: {},
      total: 0,
      fetching: false,
      fetched: false,
    },
  })

  models[namespace] = model

  model.apiAction('fetch', query => ({
    method: 'get',
    endpoint: () => (namespace === 'car::inStock' ? '/cars' : '/cars/out_of_stock'),
    query: { perPage: PAGE_SIZE, ...query },
    schema: Schemas.CAR_ARRAY,
  }), query => ({
    query,
  }))

  model.apiAction('fetchOne', id => ({
    method: 'get',
    endpoint: `/cars/${id}`,
    schema: Schemas.CAR,
  }))

  model.apiAction('fetchEdit', id => ({
    method: 'get',
    endpoint: `/cars/${id}/edit`,
    schema: Schemas.CAR,
  }))

  model.apiAction('create', data => ({
    method: 'post',
    body: data,
    endpoint: '/cars',
    schema: Schemas.CAR,
  }))

  model.apiAction('update', data => ({
    method: 'put',
    body: data,
    endpoint: `/cars/${data.car.id}`,
    schema: Schemas.CAR,
  }))

  model.apiAction('destroy', id => ({
    method: 'del',
    endpoint: `/cars/${id}`,
  }))

  model.apiAction('updateImage', (carId, data) => ({
    method: 'put',
    body: data,
    endpoint: `/cars/${carId}/update_images`,
    schema: Schemas.CAR,
  }))

  model.reducer(crud(model))
  model.reducer(pagination(model.fetch))
  model.reducer(query(model.fetch))

  model.selector('list',
    () => Entity.getState().car,
    () => model.getState().ids,
    (entities, ids) => ids.map(id => entities[id])
  )

  model.selector('one',
    () => Entity.getState().car,
    id => id,
    (entities, id) => entities && entities[id]
  )

  model.selector('defaultValues',
    id => Entity.getState().car && Entity.getState().car[id],
    () => Auth.getState().user,
    (car, currentUser) => {
      if (car) {
        const acquisitionTransfer = car.acquisitionTransfer
        return {
          car: {
            ...car,
            imagesAttributes: car.images,
            cooperationCompanyRelationshipsAttributes: car.cooperationCompanyRelationships,
          },
          acquisitionTransfer: {
            ...acquisitionTransfer,
            imagesAttributes: acquisitionTransfer.images,
          },
          publishers: {
            che168: car.che168PublishRecord || {},
          },
        }
      }

      return {
        car: {
          companyId: car.companyId,
          acquisitionType: 'acquisition',
          acquirerId: currentUser.id,
          acquiredAt: moment().format('YYYY-MM-DD'),
          cooperationCompanyRelationships: [
            { cooperationCompanyId: '', cooperationPriceWan: '' },
          ],
          state: 'in_hall',
          fuelType: 'gasoline',
          emissionStandard: 'guo_4',
          licenseInfo: 'licensed',
          starRating: 5,
          allowedMortgage: true,
          manufacturerConfiguration: [],
        },
      }
    }
  )


  function* watchImageSave() {
    yield* takeEvery(model.updateImage.success, function* () {
      yield put(hide('carImageUpload'))
      yield put(Notification.show({
        type: 'success',
        message: '保存成功',
      }))
    })
  }

  function* watchSave() {
    yield* takeEvery(model.update.success, function* () {
      yield put(goBack())
      yield put(Notification.show({
        type: 'success',
        message: '保存成功',
      }))
    })
  }

  model.effect(function* () {
    yield [
      fork(watchImageSave),
      fork(watchSave),
    ]
  })

  return model
}
