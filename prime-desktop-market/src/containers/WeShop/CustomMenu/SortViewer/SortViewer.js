import React, { Component, PropTypes } from 'react'
import styles from '../CustomMenu.scss'
import GroupMenuBar from './GroupMenuBar'

export default class SortViewer extends Component {
  static propTypes = {
    title: PropTypes.string.isRequired,
    menus: PropTypes.array,
    handleOrderChange: PropTypes.func.isRequired,
  }

  render() {
    const { title, menus, handleOrderChange } = this.props

    return (
      <div className={styles.preview}>
        <div className={styles.main}>
          <div className={styles.head}>{title}</div>
          <div className={styles.body}>
            <GroupMenuBar menus={menus} handleOrderChange={handleOrderChange} />
          </div>
        </div>
      </div>
    )
  }
}
