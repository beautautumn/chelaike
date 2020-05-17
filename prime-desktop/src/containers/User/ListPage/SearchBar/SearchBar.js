import React, { Component, PropTypes } from 'react'
import { Row, Col } from 'antd'
import { Segment } from 'components'
import SearchBarForm from './SearchBarForm'

export default class SearchBar extends Component {
  static propTypes = {
    enumValues: PropTypes.object.isRequired,
    onSearch: PropTypes.func.isRequired,
    onSearchReset: PropTypes.func.isRequired
  }

  render() {
    const { enumValues, onSearch, onSearchReset } = this.props

    return (
      <Segment className="ui segment">
        <Row>
          <Col span="24">
            <SearchBarForm
              initialValues={{}}
              enumValues={enumValues}
              onSubmit={onSearch}
              onReset={onSearchReset}
            />
          </Col>
        </Row>
      </Segment>
    )
  }
}
