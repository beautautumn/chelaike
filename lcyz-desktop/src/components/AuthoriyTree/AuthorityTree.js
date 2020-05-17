import React, { Component, PropTypes } from 'react'
import { Tree } from 'antd'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import { fetch as fetchAuthorities } from 'redux/modules/authorities'

const { TreeNode } = Tree

@connect(
  (state) => ({
    authorities: state.authorities.authorities
  }),
  (dispatch) => ({
    ...bindActionCreators({
      fetchAuthorities
    }, dispatch)
  })
)
export default class AuthorityTree extends Component {
  static propTypes = {
    value: PropTypes.arrayOf(PropTypes.string),
    defaultValue: PropTypes.arrayOf(PropTypes.string),
    onChange: PropTypes.func.isRequired,
    disabled: PropTypes.bool,
    authorities: PropTypes.array,
  }

  componentWillMount() {
    const { authorities, fetchAuthorities } = this.props
    if (!authorities) {
      fetchAuthorities()
    }
  }

  onCheck = (nodes) => {
    const value = nodes.filter(node => !node.startsWith('category-'))
    this.props.onChange(value)
  }

  renderNodes() {
    const { disabled, authorities } = this.props
    return authorities.map((group) => (
      <TreeNode key={'category-' + group.category} title={group.category} disabled={disabled}>
        {group.authorities.map((authority) => (
          <TreeNode key={authority.name} title={authority.name} isLeaf disabled={disabled} />
        ))}
      </TreeNode>
    ))
  }

  render() {
    const { value, defaultValue, authorities } = this.props

    if (!authorities) return null

    return (
      <Tree
        multiple
        checkable
        defaultExpandAll
        defaultCheckedKeys={defaultValue}
        checkedKeys={value}
        onCheck={this.onCheck}
      >
        {this.renderNodes()}
      </Tree>
    )
  }
}
