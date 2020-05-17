import React from 'react'
import { Layout } from 'antd'
import styles from './Content.scss'

const Content = ({ children }) => {
  return (
    <Layout.Content className={styles.content}>
      {children}
    </Layout.Content>
  )
}

export default Content
