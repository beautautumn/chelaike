import { fork } from 'redux-saga/effects'
import auth from './auth'
import carImport from './car/import'
import notification from './notification'

export default function* root() {
  yield [
    fork(auth),
    fork(carImport),
    fork(notification),
  ]
}
