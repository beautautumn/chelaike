import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux-polymorphic'
import { connect } from 'react-redux'
import { fetch } from 'redux/modules/userSelect'
import { Select } from 'components'
import { visibleEntitiesSelector } from 'redux/selectors/entities'

@connect(
  (state, { as }) => ({
    users: visibleEntitiesSelector('users')(state, state.userSelect[as].ids),
    fetching: state.userSelect[as].fetching,
    fetched: state.userSelect[as].fetched
  }),
  (dispatch, { as }) => ({
    ...bindActionCreators({ fetch }, dispatch, as)
  })
)
export default class UserSelect extends Component {
  static propTypes = {
    users: PropTypes.array.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    fetch: PropTypes.func.isRequired,
    as: PropTypes.string.isRequired,
  }

  componentWillMount() {
    if (!this.props.fetched && !this.props.fetching) {
      const roles = {
        manager: { authorities_any: ['求购客户管理', '出售客户管理', '全部客户管理'] },
        acquirer: { authorities_any: ['出售客户跟进'] },
        seller: { authorities_any: ['求购客户跟进'] },
        financer: { authorities_any: ['财务管理'] },
        all: {}
      }
      this.props.fetch({ query: roles[this.props.as] })
    }
  }

  render() {
    const { users, ...passedProps } = this.props

    const items = users.map(user => ({
      value: user.id,
      text: `${user.firstLetter} ${user.name}`
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
