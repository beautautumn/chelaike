import React from 'react'
import { PureComponent } from 'react-pure-render'
import SearchBar from './SearchBar/SearchBar'
import Toolbar from './Toolbar/Toolbar'
import List from './List/List'
import { AssignModal, EditModal } from '..'

export default class ServicePage extends PureComponent {
  render() {
    return (
      <div>
        <SearchBar />
        <Toolbar />
        <List />
        <EditModal as="service" />
        <AssignModal as="service" />
      </div>
    )
  }
}
