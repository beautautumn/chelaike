import React, { PropTypes } from 'react'
import { Button } from 'antd'
import { Segment, SortButton } from 'components'
import { exportLink } from 'helpers/car'
import can from 'helpers/can'
import styles from './style.scss'

export default function ToolBar({ fields, total, query, currentUser, handleSort }) {
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
          找到匹配车辆共 {total} 台
        </div>

        <div className={styles.actions}>
          {can('库存明细导出') &&
            <a
              className="ant-btn ant-btn-lg"
              href={exportLink(query.query, currentUser, 'cars_in_stock')}
            >
              车辆导出
            </a>
          }
        </div>
      </div>
    </Segment>
  )
}

ToolBar.propTypes = {
  fields: PropTypes.array.isRequired,
  total: PropTypes.number.isRequired,
  query: PropTypes.object.isRequired,
  currentUser: PropTypes.object.isRequired,
  handleSort: PropTypes.func.isRequired,
}
