import React from 'react'
import { Route, IndexRoute } from 'react-router'
import { getToken } from 'redux/modules/auth'
import App from './containers/App/App'
import AppLayout from './containers/AppLayout/AppLayout'
import AppViewer from './containers/AppViewer/AppViewer'
import Home from './containers/Home/Home'
import NotFound from './containers/NotFound/NotFound'
import * as Auth from './containers/Auth'
import * as Car from './containers/Car'
import * as ServiceAppointment from './containers/ServiceAppointment'
import * as Company from './containers/Company'
import * as License from './containers/License'
import * as Password from './containers/Password'
import * as PrepareRecord from './containers/PrepareRecord'
import * as Role from './containers/Role'
import * as Setting from './containers/Setting'
import * as StockOutCar from './containers/StockOutCar'
import * as User from './containers/User'
import * as Intention from './containers/Intention'
import * as ImportTask from './containers/ImportTask'
import * as WeShop from './containers/WeShop'
import * as Statistics from './containers/Statistics'
import * as Finance from './containers/Finance'

export default () => {
  const requireAuth = (nextState, replaceState) => {
    if (!getToken()) {
      replaceState(null, '/login')
    }
  }

  return (
    <Route component={App}>
      <Route path="login" component={Auth.LoginPage} />
      <Route path="signup" component={Auth.SignupPage} />
      <Route path="passwords" component={Password.Layout} >
        <Route path="recover" component={Password.RecoverPage} />
        <Route path="new" component={Password.NewPage} />
      </Route>
      <Route path="app_viewer" component={AppViewer} />
      <Route component={AppLayout} onEnter={requireAuth}>
        <Route path="/" component={Home} />
        <Route path="cars" component={Car.ListPage} />
        <Route path="cars/new" component={Car.EditPage} />
        <Route path="cars/import" component={Car.ImportPage} />
        <Route path="cars/:id/edit" component={Car.EditPage} />
        <Route path="cars/:id" component={Car.DetailPage} />
        <Route path="open_cars/:id" component={Car.OpenDetailPage} />
        <Route path="service_appointments" component={ServiceAppointment.ListPage} />
        <Route path="licenses" component={License.ListPage} />
        <Route path="prepare_records" component={PrepareRecord.ListPage} />
        <Route path="stock_out_cars" component={StockOutCar.ListPage} />
        <Route path="stock_out_cars/:id/edit" component={Car.EditPage} />
        <Route path="company" component={Company.EditPage} />
        <Route path="roles" component={Role.ListPage} />
        <Route path="roles/new" component={Role.EditPage} />
        <Route path="roles/:id/edit" component={Role.EditPage} />
        <Route path="users" component={User.ListPage} />
        <Route path="users/new" component={User.EditPage} />
        <Route path="users/:id/edit" component={User.EditPage} />
        <Route path="setting" component={Setting.Layout} >
          <IndexRoute component={Setting.Channel.ListPage} />
          <Route path="shops" component={Setting.Shop.ListPage} />
          <Route path="channels" component={Setting.Channel.ListPage} />
          <Route path="publishers_profile" component={Setting.PublisherProfile.ListPage} />
          <Route path="warranties" component={Setting.Warranty.ListPage} />
          <Route path="intention_levels" component={Setting.IntentionLevel.ListPage} />
          <Route
            path="guest_reminder_setting"
            component={Setting.GuestReminderSetting.ListPage}
          />
          <Route
            path="intention_recovery_time"
            component={Setting.IntentionRecoveryTime.ListPage}
          />
          <Route path="insurance_companies" component={Setting.InsuranceCompany.ListPage} />
          <Route path="mortgage_companies" component={Setting.MortgageCompany.ListPage} />
          <Route path="cooperation_companies" component={Setting.CooperationCompany.ListPage} />
          <Route path="system" component={Setting.System} />
        </Route>
        <Route path="weshop">
          <Route path="custom_menu" component={WeShop.CustomMenu} />
          <Route path="binding" component={WeShop.Binding} />
        </Route>
        <Route path="intentions">
          <Route path="following" component={Intention.FollowingPage} />
          <Route path="service" component={Intention.ServicePage} />
          <Route path="recovery" component={Intention.RecoveryPage} />
        </Route>
        <Route path="import_tasks" component={ImportTask.ListPage} />
        <Route path="maintenance_record_statistics" component={Statistics.MaintenanceRecordPage} />
        <Route path="finance">
          <Route path="single_car" component={Finance.SingleCar} />
          <Route path="shop_fees" component={Finance.ShopFeePage} />
          <Route path="configuration" component={Finance.Configuration} />
        </Route>
      </Route>
      <Route path="*" component={NotFound} status={404} />
    </Route>
  )
}
