import React from 'react'
import { PureComponent } from 'react-pure-render'
import SearchBar from './SearchBar/SearchBar'
import Toolbar from './Toolbar/Toolbar'
import List from './List/List'
import { AssignModal, EditModal, PushModal, PushHistoryModal, ImportModal, ShareModal } from '..'
import Helmet from 'react-helmet'

export default class FollowingPage extends PureComponent {
  render() {
    return (
      <div>
        <Helmet title="客户跟踪" />
        <SearchBar />
        <Toolbar />
        <List />
        <EditModal as="following" />
        <AssignModal as="following" />
        <PushModal />
        <PushHistoryModal />
        <ImportModal />
        <ShareModal />
      </div>
    )
  }
}
