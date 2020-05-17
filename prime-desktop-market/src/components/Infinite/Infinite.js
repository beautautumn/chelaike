// Implement based on http://ravikiranj.net/posts/2011/code/how-implement-infinite-scrolling-using-native-javascript-and-yui3/
import { Component, PropTypes } from 'react'

export default class Infinite extends Component {
  static propTypes = {
    children: PropTypes.oneOfType([
      PropTypes.element,
      PropTypes.array
    ]),
    scrollDisabled: PropTypes.bool,
    onScroll: PropTypes.func
  }

  componentDidMount() {
    window.addEventListener('scroll', this.handleScroll)
  }

  componentWillUnmount() {
    window.removeEventListener('scroll', this.handleScroll)
  }

  handleScroll = () => {
    if (this.isEnd() && !this.props.scrollDisabled) {
      if (this.props.onScroll) {
        this.props.onScroll()
      }
    }
  }

  isEnd() {
    const pageHeight = document.documentElement.scrollHeight
    const scrollPos = window.pageYOffset
    const clientHeight = document.documentElement.clientHeight

    return (pageHeight - (scrollPos + clientHeight) < 800)
  }

  render() {
    return this.props.children
  }
}
