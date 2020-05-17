import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { search, createImport, startPolling, stopPolling } from 'redux/modules/carImport'
import debounce from 'lodash/debounce'
import SearchBar from './SearchBar'
import ProgressBar from './ProgressBar'
import List from './List'
import Helmet from 'react-helmet'

@connect(
  state => ({
    companies: state.carImport.companies,
    progress: state.carImport.progress,
  }),
  dispatch => bindActionCreators({
    search,
    createImport,
    startPolling,
    stopPolling,
  }, dispatch)
)
export default class ImportPage extends Component {
  static propTypes = {
    companies: PropTypes.array.isRequired,
    progress: PropTypes.number,
    search: PropTypes.func.isRequired,
    createImport: PropTypes.func.isRequired,
    startPolling: PropTypes.func.isRequired,
    stopPolling: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.search = debounce(this.props.search, 300)
  }

  componentWillMount() {
    this.props.startPolling()
  }

  componentWillUnmount() {
    this.props.stopPolling()
  }

  handleChange = event => {
    this.search(event.currentTarget.value)
  }

  handleImport = id => event => {
    event.preventDefault()
    this.props.createImport(id)
  }

  render() {
    const { companies, progress } = this.props

    return (
      <div>
        <Helmet title="车辆导入" />
        <h1>车辆导入</h1>
        <SearchBar handleChange={this.handleChange} />
        {typeof progress !== 'undefined' && <ProgressBar progress={progress} />}
        <List companies={companies} handleImport={this.handleImport} />
      </div>
    )
  }
}
