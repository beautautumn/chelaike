import React from 'react';
import { Table } from 'antd';
import styles from './FInventoryTable.scss';
import { Link } from 'react-router-dom';

export default class FInventoryTable extends React.Component {
  handlePage = page => {
    this.props.fetch();
  };

  render() {
    const { data, query, total, onPageChange, loading } = this.props;

    console.log('列表的数据是：======', data);

    const stores = data.reduce((acc, cur) => {
      const firstStore = {
        recordId: cur.id,
        storeCount: cur.inventoryStoreDtos.length,
        ...cur,
        ...cur.inventoryStoreDtos[0]
      };
      acc.push(...cur.inventoryStoreDtos);
      acc.fill(firstStore, 0, 1);
      return acc;
    }, []);

    console.log('处理后列表的数据是：======', stores);
    let columns = [
      {
        dataIndex: 'debtorName',
        title: '车商名称',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          if (row.storeCount) {
            obj.props.rowSpan = row.storeCount;
          } else {
            obj.props.rowSpan = 0;
          }
          return obj;
        }
      },
      {
        dataIndex: 'storeName',
        title: '门店名',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          return obj;
        }
      },
      {
        dataIndex: 'inventoryStartTime',
        title: '盘库时间',
        render: (value, row, index) => {
          const obj = {
            children: (
              <span>
                {row.inventoryStartTime}至{row.inventoryEndTime}
              </span>
            ),
            props: {}
          };
          return obj;
        }
      },
      {
        dataIndex: 'storeAddress',
        title: '门店地址',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          return obj;
        }
      },
      {
        dataIndex: 'inventoryAddress',
        title: '盘库地址',
        render: (value, row, index) => {
          const obj = {
            children: (
              <div>
                {row.positioningAbnormal === true ? (
                  <span className={styles.color}>{row.inventoryAddress}</span>
                ) : (
                  <span>{row.inventoryAddress}</span>
                )}
              </div>
            ),
            props: {}
          };
          return obj;
        }
      },
      {
        dataIndex: 'userName',
        title: '盘库员',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          console.log('userName', value);
          return obj;
        }
      },
      {
        dataIndex: 'countInHall',
        title: '盘库数量[在厅(辆)]',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          if (row.storeCount) {
            obj.props.rowSpan = row.storeCount;
          } else {
            obj.props.rowSpan = 0;
          }
          return obj;
        }
      },
      {
        dataIndex: 'countInBase',
        title: '在库(辆)',
        render: (value, row, index) => {
          const obj = {
            children: value,
            props: {}
          };
          if (row.storeCount) {
            obj.props.rowSpan = row.storeCount;
          } else {
            obj.props.rowSpan = 0;
          }

          return obj;
        }
      },
      {
        title: '盘库异常车辆',
        children: [
          {
            dataIndex: 'countLoanAndNotHall',
            title: '质押不在厅',
            render: (value, row, index) => {
              const obj = {
                children: value,
                props: {}
              };
              if (row.storeCount) {
                obj.props.rowSpan = row.storeCount;
              } else {
                obj.props.rowSpan = 0;
              }
              return obj;
            }
          },
          {
            dataIndex: 'countNotHallAndInBase',
            title: '在库不在厅',
            render: (value, row, index) => {
              const obj = {
                children: value,
                props: {}
              };
              if (row.storeCount) {
                obj.props.rowSpan = row.storeCount;
              } else {
                obj.props.rowSpan = 0;
              }

              return obj;
            }
          },
          {
            dataIndex: 'countInHallAndLeaveBase',
            title: '在厅已出库',
            render: (value, row, index) => {
              const obj = {
                children: value,
                props: {}
              };
              if (row.storeCount) {
                obj.props.rowSpan = row.storeCount;
              } else {
                obj.props.rowSpan = 0;
              }

              return obj;
            }
          },
          {
            dataIndex: 'countInHallAndOutBase',
            title: '在厅未入库',
            render: (value, row, index) => {
              const obj = {
                children: value,
                props: {}
              };
              if (row.storeCount) {
                obj.props.rowSpan = row.storeCount;
              } else {
                obj.props.rowSpan = 0;
              }

              return obj;
            }
          }
        ]
      },
      {
        key: 'operations',
        title: '操作',
        render: (value, row, index) => {
          const obj = {
            children: (
              <Link
                className={styles.button}
                to={`/inventorys/funderCompany/${value.recordId}`}
              >
                查看详情
              </Link>
            ),
            props: {}
          };
          if (row.storeCount) {
            obj.props.rowSpan = row.storeCount;
          } else {
            obj.props.rowSpan = 0;
          }

          return obj;
        }
      }
    ];

    const paginationProps = {
      pageSize: +query.size,
      current: +query.page,
      total,
      onChange: onPageChange
    };
    return (
      <Table
        className={styles.table}
        columns={columns}
        dataSource={stores}
        loading={loading}
        size="middle"
        rowKey="storeRecordsId"
        pagination={paginationProps}
        scroll={{ x: 1400 }}
        bordered
      />
    );
  }
}
