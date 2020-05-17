import React from 'react'
import { PureComponent } from 'react-pure-render'
import SearchBar from './SearchBar/SearchBar'
import Toolbar from './Toolbar/Toolbar'
import List from './List/List'
import Helmet from 'react-helmet'
import { PushHistoryModal } from '..'

export default class RecoveryPage extends PureComponent {
  render() {
    return (
      <div>
        <Helmet title="意向回收" />
        <SearchBar />
        <Toolbar />
        <List />
        <PushHistoryModal />
      </div>
    )
  }
}
