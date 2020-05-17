import React, { Component } from 'react'
import goToTopImg from './goToTop.png'
import cx from 'classnames'
import styles from './GoToTopButton.scss'

export default class GoToTopButton extends Component {

  constructor(props) {
    super(props)

    this.state = { show: false }
  }

  componentDidMount() {
    window.addEventListener('scroll', this.handleScroll)
  }

  componentWillUnmount() {
    window.removeEventListener('scroll', this.handleScroll)
  }

  handleScroll = () => {
    const scrollTop = document.documentElement.scrollTop || document.body.scrollTop
    if (scrollTop >= 300 && !this.state.show) {
      this.setState({ show: true })
    }
    if (scrollTop < 300 && this.state.show) {
      this.setState({ show: false })
    }
  }

  render() {
    const { show } = this.state
    return (
      <div className={cx(styles.goToTop, { [styles.show]: show })}>
        <a href="#top"><img role="presentation" src={goToTopImg} /></a>
      </div>
    )
  }
}
