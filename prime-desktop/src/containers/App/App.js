import { Component, PropTypes } from 'react'
import 'antd/index.less'
import './App.css'

export default class App extends Component {
  static propTypes = {
    children: PropTypes.object.isRequired,
  };

  render() {
    return this.props.children
  }
}
