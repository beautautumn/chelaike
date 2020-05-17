import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import userFactory from 'models/user'
import { Select } from 'components'

const User = userFactory('user::select')

@connect(
  _state => ({
    users: User.select('list'),
    fetching: User.getState().fetching,
    fetched: User.getState().fetched,
  })
)
export default class UserSelect extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    users: PropTypes.array.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
  }

  componentWillMount() {
    const { dispatch, fetched, fetching } = this.props
    if (!fetched && !fetching) {
      dispatch(User.fetch())
    }
  }

  render() {
    const { users, ...passedProps } = this.props

    const items = users.map(user => ({
      value: user.id,
      text: `${user.firstLetter} ${user.name}`,
    }))

    return (
      <Select
        items={items}
        prompt="选择人员"
        {...passedProps}
      />
    )
  }
}
