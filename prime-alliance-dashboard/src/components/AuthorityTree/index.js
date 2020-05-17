import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Authority from 'models/authority'
import { Tree } from 'antd'

const { TreeNode } = Tree

@connect(
  _state => ({
    authorities: Authority.getState().data,
    fetching: Authority.getState().fetching,
    fetched: Authority.getState().fetched,
  })
)
export default class AuthorityTree extends Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    value: PropTypes.arrayOf(PropTypes.string),
    onChange: PropTypes.func.isRequired,
    fetching: PropTypes.bool.isRequired,
    fetched: PropTypes.bool.isRequired,
    authorities: PropTypes.array.isRequired,
    disabled: PropTypes.bool,
  }

  componentWillMount() {
    const { dispatch, fetching, fetched } = this.props
    if (!fetching || !fetched) {
      dispatch(Authority.fetch())
    }
  }

  handleCheck = nodes => {
    const value = nodes.filter(node => !node.startsWith('category-'))
    this.props.onChange(value)
  }

  renderNodes() {
    const { disabled, authorities } = this.props
    return authorities.map((group) => (
      <TreeNode key={`category-${group.category}`} title={group.category} disabled={disabled}>
        {group.authorities.map((authority) => (
          <TreeNode key={authority.name} title={authority.name} isLeaf disabled={disabled} />
        ))}
      </TreeNode>
    ))
  }

  render() {
    const { value, authorities } = this.props

    if (authorities.length === 0) {
      return null
    }

    return (
      <Tree
        multiple
        checkable
        defaultExpandAll
        checkedKeys={value}
        onCheck={this.handleCheck}
      >
        {this.renderNodes()}
      </Tree>
    )
  }
}
