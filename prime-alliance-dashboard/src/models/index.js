import Alliance from './alliance'
import Auth from './auth'
import Authority from './authority'
import carFactory from './car'
import Channel from './channel'
import Company from './company'
import Entity from './entity'
import EnumValue from './enumValue'
import Form from './form'
import Modal from './modal'
import Notification from './notification'
import Oss from './oss'
import Role from './role'
import StockOutInventory from './stockOutInventory'
import userFactory from './user'
import Warranty from './warranty'
import brandFactory from './brand'
import Seires from './series'
import Style from './style'
import IntentionIntention from './intention/intention'
import IntentionPushHistory from './intention/pushHistory'
import IntentionLevel from './intention/level'
import City from './city'
import Province from './province'
import MaintenanceRecord from './maintenanceRecord'

export default [
  Alliance,
  Auth,
  Authority,
  carFactory('car::inStock'),
  carFactory('car::stockOut'),
  carFactory('car::listModal'),
  Channel,
  Company,
  Entity,
  EnumValue,
  Form,
  Modal,
  Notification,
  Oss,
  Role,
  StockOutInventory,
  userFactory('user::list'),
  userFactory('user::select'),
  Warranty,
  brandFactory('brand::all'),
  brandFactory('brand::inStock'),
  brandFactory('brand::outOfStock'),
  Seires,
  Style,
  IntentionIntention,
  IntentionPushHistory,
  IntentionLevel,
  City,
  Province,
  MaintenanceRecord,
]

