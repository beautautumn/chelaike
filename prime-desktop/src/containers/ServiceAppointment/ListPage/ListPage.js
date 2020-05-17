import React from 'react'
import { PureComponent } from 'react-pure-render'
import SearchBar from './SearchBar/SearchBar'
import ToolBar from './ToolBar/ToolBar'
import List from './List/List'

export default class ListPage extends PureComponent {
  render() {
    return (
      <div>
        <SearchBar />
        <ToolBar />
        <List />
      </div>
    )
  }
}
