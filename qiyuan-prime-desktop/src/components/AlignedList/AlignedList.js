import React, { Component, PropTypes } from 'react'
import cx from 'classnames'
import styles from './AlignedList.scss'


export default class AlignedList extends Component {
  static propTypes = {
    data: PropTypes.array,
    dashed: PropTypes.bool
  }

  static defaultProps = {
    data: []
  }

  render() {
    const { data, dashed } = this.props

    return (
      <ul className={styles.alignedList}>
        {data.map((item, index) => (
          <li key={index} className={cx({ [styles.dashed]: dashed })}>
            <span className={styles.label}>{item.label}</span>
            <span className={styles.text}>{item.text}</span>
          </li>
        ))}
      </ul>
    )
  }
}
