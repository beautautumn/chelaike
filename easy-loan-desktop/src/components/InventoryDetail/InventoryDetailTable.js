import React from 'react';
import { Table, Tabs } from 'antd';
import defaultCarImg from '../../../public/car.png';
import debtorImg from '../../../public/debtor.png';
import WarningImg from '../../../public/warning.png';
import ErrorImg from '../../../public/error.png';
import Pie from '../PieReact';
import styles from './InventoryDetailTable.scss';
import find from 'lodash/find';
import scale from '../../utils/scaleImage';
import { Link } from 'react-router-dom';

const TabPane = Tabs.TabPane;

export default class DetailTable extends React.Component {
  renderStates(status) {
    if (!status) return;

    const colorMap = {
      已质押: '#4188F2',
      质押: '#4188F2',
      未入库: '#FF5C47',
      当前在库: '#29CC7A',
      已出库: '#DB941E'
    };

    const statusArray = status.split('/');
    if (statusArray.length === 1) {
      return (
        <span style={{ color: colorMap[statusArray[0]] }}>
          {statusArray[0]}
        </span>
      );
    } else {
      const stateLables = statusArray.map((state, i) => (
        <span key={i} style={{ color: colorMap[state] }}>
          {i === statusArray.length - 1 ? (
            state
          ) : (
            <span>
              {state}
              <span style={{ color: 'black' }}>/</span>
            </span>
          )}
        </span>
      ));
      return <div>{stateLables}</div>;
    }
  }

  render() {
    /*const dataPie = [
      { value: 2, name: '质押不在厅', valuePercent: '0' },
      { value: 1, name: '在库不在厅', valuePercent: '0' },
      { value: 20, name: '在厅已出库', valuePercent: '0' },
      { value: 1, name: '在厅未入库', valuePercent: '0' }
    ];*/

    function callback(key) {
      console.log(key);
    }

    const { data } = this.props;
    let pieData = [];
    let abnormalTotal;
    let storesData = [];
    let storesArray = [];
    let i = 0;
    let name = '';
    let countInHall = '';
    let countInHallAndLeaveBase = '';
    let countInHallAndOutBase = '';
    let countLoanAndNotHall = '';
    let countNotHallAndInBase = '';
    let storesName = [];
    let usersName = [];
    let abStoresArray = [];
    let loanAndNotHallCar = [];
    let notHallAndInBaseCar = [];
    let inHallAndLeaveBaseCar = [];
    let inHallAndOutBaseCar = [];
    let corverImage = '';
    let vinImage = '';
    let dataSource = [];
    if (data[0]) {
      /*for (let k = 0; k < data[0].pieChart.length; k++) {
        if (data[0].pieChart[k].name === '质押不在厅') {
          countLoanAndNotHall = data[0].pieChart[k].value;
        } else if (data[0].pieChart[k].name === '在厅已出库') {
          countInHallAndLeaveBase = data[0].pieChart[k].value;
        } else if (data[0].pieChart[k].name === '在库不在厅') {
          countNotHallAndInBase = data[0].pieChart[k].value;
        } else {
          countInHallAndOutBase = data[0].pieChart[k].value;
        }
      }*/

      pieData = data[0].pieChart;
      abnormalTotal = data[0].countInBase;
      countLoanAndNotHall = pieData[0].value;
      countNotHallAndInBase = pieData[1].value;
      countInHallAndLeaveBase = pieData[2].value;
      countInHallAndOutBase = pieData[3].value;
      pieData[0].itemStyle = { normal: { color: '#4A90E2' } };
      pieData[1].itemStyle = { normal: { color: '#B8E986' } };
      pieData[2].itemStyle = { normal: { color: '#F8E71C' } };
      pieData[3].itemStyle = { normal: { color: '#FC8070' } };
      pieData[0].name = '质押不在厅(' + pieData[0].value + '辆)';

      pieData[1].name = '在库不在厅(' + pieData[1].value + '辆)';

      pieData[2].name = '在厅已出库' + pieData[2].value + '辆)';

      pieData[3].name = '在厅未入库(' + pieData[3].value + '辆)';
      console.log('pieData========', pieData);
      storesData = data[0].inventoryStoreDtos;
      loanAndNotHallCar = data[0].loanAndNotHallCar;
      notHallAndInBaseCar = data[0].notHallAndInBaseCar;
      inHallAndLeaveBaseCar = data[0].inHallAndLeaveBaseCar;
      inHallAndOutBaseCar = data[0].inHallAndOutBaseCar;

      console.log('notHallAndInBaseCar', notHallAndInBaseCar);
      name = data[0].debtorName;
      countInHall = data[0].countInHall;

      console.log('data[0]', data[0]);
      console.log('storesData', storesData);
      for (i; i < storesData.length; i++) {
        dataSource[i] = storesData[i];
        if (storesData[i].countStoreInvnetoryCar > 0) {
          storesArray.push(dataSource[i]);
        } else {
          abStoresArray.push(storesData[i]);
        }
      }
      console.log('storesArray -------', storesArray);
      console.log('abStoresArray -------', abStoresArray);

      for (let j = 0; j < storesArray.length; j++) {
        if (storesArray[j]) {
          storesName[j] = storesArray[j].storeName;
          usersName[j] = storesArray[j].userName;
        }
      }
      console.log('storesName===', storesName);
    }
    let abColumns = [
      {
        key: 'carPic',
        title: '车辆图片',
        render: (text, record) => {
          corverImage = find(record.carImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {corverImage ? (
                <img src={scale(corverImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },

      {
        key: 'carName',
        title: '车辆名称',
        render: (text, record) => {
          return (
            <div>
              <a target="_blank" href={`http://${record.weshopUrl}`}>
                {`${record.brandName} ${record.seriesName} ${record.styleName}`}
              </a>
            </div>
          );
        }
      },
      {
        key: 'vin',
        title: '车架号',
        dataIndex: 'vin'
      },
      {
        key: 'inventoryAddressPc',
        title: '盘库地址',
        render: (text, record) => {
          return (
            <div>
              {record.positioningAbnormal === true ? (
                <span className={styles.color}>
                  <img src={WarningImg} alt="" /> {record.inventoryAddressPc}
                </span>
              ) : (
                <span>{record.inventoryAddress}</span>
              )}
            </div>
          );
        }
      },
      {
        key: 'stateText',
        title: '状态',
        render: (text, record) => {
          return this.renderStates(record.stateText);
        }
      }
    ];
    let inHallLeaveBaseColumns = [
      {
        key: 'carPic',
        title: '车辆图片',
        render: (text, record) => {
          corverImage = find(record.carImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {corverImage ? (
                <img src={scale(corverImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },
      {
        key: 'vinPic',
        title: '盘库扫码图',
        render: (text, record) => {
          vinImage = find(record.scanningImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {vinImage ? (
                <img src={scale(vinImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },
      {
        key: 'carName',
        title: '车辆名称',
        render: (text, record) => {
          return (
            <div>
              <a target="_blank" href={`http://${record.weshopUrl}`}>
                {`${record.brandName} ${record.seriesName} ${record.styleName}`}
              </a>
            </div>
          );
        }
      },
      {
        key: 'vin',
        title: '车架号',
        dataIndex: 'vin'
      },
      {
        key: 'inventoryAddressPc',
        title: '盘库地址',
        render: (text, record) => {
          return (
            <div>
              {record.positioningAbnormal === true ? (
                <span className={styles.color}>
                  <img src={WarningImg} alt="" /> {record.inventoryAddressPc}
                </span>
              ) : (
                <span>{record.inventoryAddress}</span>
              )}
            </div>
          );
        }
      },
      {
        key: 'stateText',
        title: '状态',
        render: (text, record) => {
          return this.renderStates(record.stateText);
        }
      }
    ];
    let inHallOutBaseColumns = [
      {
        key: 'vinPic',
        title: '盘库扫码图',
        render: (text, record) => {
          vinImage = find(record.scanningImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {vinImage ? (
                <img src={scale(vinImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },
      {
        key: 'carName',
        title: '车辆名称',
        render: (text, record) => {
          return (
            <div>
              <a target="_blank" href={`http://${record.weshopUrl}`}>
                {`${record.brandName} ${record.seriesName} ${record.styleName}`}
              </a>
            </div>
          );
        }
      },
      {
        key: 'vin',
        title: '车架号',
        dataIndex: 'vin'
      },
      {
        key: 'inventoryAddressPc',
        title: '盘库地址',
        render: (text, record) => {
          return (
            <div>
              {record.positioningAbnormal === true ? (
                <span className={styles.color}>
                  <img src={WarningImg} alt="" />
                  {record.inventoryAddressPc}
                </span>
              ) : (
                <span>{record.inventoryAddress}</span>
              )}
            </div>
          );
        }
      },
      {
        key: 'stateText',
        title: '状态',
        render: (text, record) => {
          return this.renderStates(record.stateText);
        }
      }
    ];
    let columns = [
      /* {
             key: 'storeName',
             title: '门店',
             dataIndex: 'storeName'
           },
           {
             key: 'countStoreInvnetoryCar',
             title: '车辆个数',
             dataIndex: 'countStoreInvnetoryCar'
           },*/
      {
        key: 'carPic',
        title: '车辆图片',
        render: (text, record) => {
          corverImage = find(record.carImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {corverImage ? (
                <img src={scale(corverImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },
      {
        key: 'vinPic',
        title: '盘库扫码图',
        render: (text, record) => {
          vinImage = find(record.scanningImages, { isCover: true });
          return (
            <div className={styles.carImg}>
              {vinImage ? (
                <img src={scale(vinImage.url, '320x240')} alt="" />
              ) : (
                <img src={defaultCarImg} alt="" />
              )}
            </div>
          );
        }
      },
      {
        key: 'carName',
        title: '车辆名称',
        render: (text, record) => {
          return (
            <div>
              <a target="_blank" href={`http://${record.weshopUrl}`}>
                {`${record.brandName} ${record.seriesName} ${record.styleName}`}
              </a>
            </div>
          );
        }
      },
      {
        key: 'vin',
        title: '车架号',
        dataIndex: 'vin'
      },
      {
        key: 'inventoryAddressPc',
        title: '盘库地址',
        render: (text, record) => {
          return (
            <div>
              {record.positioningAbnormal === true ? (
                <span className={styles.color}>
                  <img src={WarningImg} alt="" /> {record.inventoryAddressPc}
                </span>
              ) : (
                <span>{record.inventoryAddress}</span>
              )}
            </div>
          );
        }
      },
      {
        key: 'stateText',
        title: '状态',
        /*render: (text, record) => {
          return (
            <div>
              {record.stateText === '已质押' ? (
                <span className={styles.inHall}>{record.stateText}</span>
              ) : record.stateText === '未入库' ? (
                <span className={styles.outBase}>{record.stateText}</span>
              ) : record.stateText === '当前在库' ? (
                <span className={styles.inBase}>{record.stateText}</span>
              ) : record.stateText === '已出库' ? (
                <span className={styles.leaveBase}>{record.stateText}</span>
              ) : (
                <span>{record.stateText}</span>
              )}
            </div>
          );
        }*/
        render: (text, record) => {
          return this.renderStates(record.stateText);
        }
      }
    ];
    return (
      <div>
        <div className={styles.addButton}>
          <Link to="/inventory">{`< 返回`}</Link>
        </div>
        <div className={styles.conceptPanel}>
          <div className={styles.debtor}>
            <div className={styles.left}>
              <div className={styles.title}>车商名称</div>
              <div className={styles.name}>{name}</div>
            </div>
            <div className={styles.debtorImg}>
              <img src={debtorImg} alt="" />
            </div>
          </div>
          <div className={styles.pie}>
            <Pie data={pieData} abnormalTotal={abnormalTotal} />
          </div>
        </div>
        <Tabs defaultActiveKey="1" type="line" onChange={callback}>
          <TabPane tab={<span>盘库详情({countInHall})辆</span>} key="1">
            {storesArray.map((d, i) => (
              <div key={i}>
                <Table
                  className={styles.table}
                  columns={columns}
                  dataSource={[d].reduce((acc, cur) => {
                    const firstCars = {
                      ...cur,
                      ...cur.inventoryCarList[0]
                    };
                    acc.push(...cur.inventoryCarList);
                    acc.fill(firstCars, 0, 1);
                    return acc;
                  }, [])}
                  size="middle"
                  rowKey="id"
                  bordered
                  title={d => {
                    return (
                      <div>
                        <div>
                          {d[0].storeName} {d[0].userName}{' '}
                          {d[0].timeout === true ? (
                            <span>
                              {d[0].inventoryStartTime} 至{
                                d[0].inventoryEndTime
                              }
                              <span className={styles.color}>(超时)</span>{' '}
                            </span>
                          ) : (
                            <span>
                              {d[0].inventoryStartTime}至{d[0].inventoryEndTime}{' '}
                            </span>
                          )}
                          {d[0].countStoreInvnetoryCar > 0
                            ? `盘${d[0].countStoreInvnetoryCar}辆`
                            : '未盘库'}
                        </div>
                        <div />
                      </div>
                    );
                  }}
                />
              </div>
            ))}
            {abStoresArray.map((d, i) => (
              <div key={i}>
                <Table
                  className={styles.table}
                  dataSource={[d]}
                  size="middle"
                  rowKey="id"
                  pagination={false}
                  bordered
                  title={d => {
                    return (
                      <div>
                        <span className={styles.color}>
                          <img src={ErrorImg} alt="" /> {d[0].storeName}{' '}
                          {d[0].userName}{' '}
                          {d[0].timeout === true ? (
                            <span>
                              {d[0].inventoryStartTime} 至{
                                d[0].inventoryEndTime
                              }
                              <span className={styles.color}>(超时)</span>{' '}
                            </span>
                          ) : (
                            <span>
                              {d[0].inventoryStartTime
                                ? `${d[0].inventoryStartTime}至${
                                    d[0].inventoryEndTime
                                  }`
                                : null}{' '}
                            </span>
                          )}
                          {d[0].countStoreInvnetoryCar > 0
                            ? `盘${d[0].countStoreInvnetoryCar}辆`
                            : '未盘库'}
                        </span>
                      </div>
                    );
                  }}
                />
              </div>
            ))}
          </TabPane>
          <TabPane
            tab={<span>质押不在厅({countLoanAndNotHall})辆</span>}
            key="2"
          >
            <Table
              className={styles.table}
              columns={abColumns}
              dataSource={loanAndNotHallCar}
              size="middle"
              rowKey="id"
              bordered
            />
          </TabPane>
          <TabPane
            tab={<span>在库不在厅({countNotHallAndInBase})辆</span>}
            key="3"
          >
            <Table
              className={styles.table}
              columns={abColumns}
              dataSource={notHallAndInBaseCar}
              size="middle"
              rowKey="id"
              bordered
            />
          </TabPane>
          <TabPane
            tab={<span>在厅已出库({countInHallAndLeaveBase})辆</span>}
            key="4"
          >
            <Table
              className={styles.table}
              columns={inHallLeaveBaseColumns}
              dataSource={inHallAndLeaveBaseCar}
              size="middle"
              rowKey="id"
              bordered
            />
          </TabPane>
          <TabPane
            tab={<span>在厅未入库({countInHallAndOutBase})辆</span>}
            key="5"
          >
            <Table
              className={styles.table}
              columns={inHallOutBaseColumns}
              dataSource={inHallAndOutBaseCar}
              size="middle"
              rowKey="id"
              bordered
            />
          </TabPane>
        </Tabs>
      </div>
    );
  }
}
