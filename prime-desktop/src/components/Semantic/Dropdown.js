import { Component, PropTypes } from 'react'
import ReactDOM from 'react-dom'

export default class Dropdown extends Component {
  static propTypes = {
    children: PropTypes.object.isRequired,
    behavior: PropTypes.string,
    options: PropTypes.object
  }

  static defaultProps = {
    options: {}
  }

  componentDidMount() {
    this.$dom = $(ReactDOM.findDOMNode(this)) // eslint-disable-line
    this.$dom.dropdown(this.props.options)
  }

  componentDidUpdate() {
    const { behavior } = this.props
    this.$dom.dropdown('refresh')
    if (behavior) {
      this.$dom.dropdown(behavior)
    }
  }

  componentWillUnmount() {
    this.$dom.dropdown('destroy')
  }

  render() {
    return this.props.children
  }
}
