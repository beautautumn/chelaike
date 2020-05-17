import React, { PropTypes } from 'react'
import { Segment } from 'components'
import Form from './Form'

export default function SearchBar({ enumValues, handleSearch, handleSearchReset }) {
  return (
    <Segment>
      <Form
        enumValues={enumValues}
        onSubmit={handleSearch}
        handleReset={handleSearchReset}
      />
    </Segment>
  )
}

SearchBar.propTypes = {
  enumValues: PropTypes.object.isRequired,
  handleSearch: PropTypes.func.isRequired,
  handleSearchReset: PropTypes.func.isRequired,
}
