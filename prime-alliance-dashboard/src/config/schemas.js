import { Schema, arrayOf } from 'normalizr'

const car = new Schema('car')
const company = new Schema('company')
const user = new Schema('user')
const role = new Schema('role')
const channel = new Schema('channel')
const warranty = new Schema('warranty')
const intention = new Schema('intention')
const intentionPushHistory = new Schema('intentionPushHistory')
const intentionLevel = new Schema('intentionLevel')

export default {
  CAR: car,
  CAR_ARRAY: arrayOf(car),
  COMPANY: company,
  COMPANY_ARRAY: arrayOf(company),
  USER: user,
  USER_ARRAY: arrayOf(user),
  ROLE: role,
  ROLE_ARRAY: arrayOf(role),
  CHANNEL: channel,
  CHANNEL_ARRAY: arrayOf(channel),
  WARRANTY: warranty,
  WARRANTY_ARRAY: arrayOf(warranty),
  INTENTION: intention,
  INTENTION_ARRAY: arrayOf(intention),
  INTENTION_PUSH_HISTORY: intentionPushHistory,
  INTENTION_PUSH_HISTORY_ARRAY: arrayOf(intentionPushHistory),
  INTENTION_LEVEL: intentionLevel,
  INTENTION_LEVEL_ARRAY: arrayOf(intentionLevel),
}
