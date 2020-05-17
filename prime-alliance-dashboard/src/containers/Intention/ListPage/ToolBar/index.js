import React, { PropTypes } from 'react'
import { Button } from 'antd'
import { Segment, SortButton } from 'components'
import styles from './style.scss'

export default function ToolBar(props) {
  const {
    fields,
    total,
    query,
    handleSort,
    handleNew,
    handleBatchAssign,
    handleExport,
  } = props

  return (
    <Segment>
      <div className={styles.toolBar}>
        <div>
          <Button.Group>
            {
              fields.map((field) => (
                <SortButton key={field.key} {...{ field, query, onSort: handleSort }} />
              ))
            }
          </Button.Group>
        </div>

        <div className={styles.total}>
          找到匹配意向共 {total} 条
        </div>

        <div className={styles.actions}>
          <Button type="primary" onClick={handleNew}>添加意向</Button>
          <Button onClick={handleBatchAssign}>批量分配</Button>
          <a className="ant-btn ant-btn-lg" href={handleExport()}>意向导出</a>
        </div>
      </div>
    </Segment>
  )
}

ToolBar.propTypes = {
  fields: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  handleSort: PropTypes.func.isRequired,
  handleNew: PropTypes.func.isRequired,
  handleBatchAssign: PropTypes.func.isRequired,
  handleExport: PropTypes.func.isRequired,
}
