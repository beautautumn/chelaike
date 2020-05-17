import { takeEvery } from 'redux-saga'
import { call } from 'redux-saga/effects'
import { notification } from 'antd'
import { show } from 'redux/modules/notification'

export default function* root() {
  yield* takeEvery(show.getType(), function* ({ payload }) {
    yield call(notification[payload.type], { ...payload, duration: 4.5 })
  })
}
