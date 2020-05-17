import React from 'react';
import echarts from 'echarts/lib/echarts'; //必须
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/legend';
import 'echarts/lib/chart/pie';

export default class Pie extends React.Component {
  constructor(props) {
    super(props);
    this.setPieOption = this.setPieOption.bind(this);
    this.initPieChart = this.initPieChart.bind(this);
  }

  initPieChart() {
    const { data, abnormalTotal } = this.props;
    console.log('abnormalTotal===', abnormalTotal);
    if (data && data.length > 0) {
      let myChart = echarts.init(this.refs.pieChart);
      let options = this.setPieOption(data, abnormalTotal);
      myChart.setOption(options);
    }
  }

  componentDidMount() {
    this.initPieChart();
  }

  componentDidUpdate() {
    this.initPieChart();
  }

  render() {
    return <div ref="pieChart" style={{ width: '100%', height: '100%' }} />;
  }

  setPieOption(data, abnormalTotal) {
    return {
      title: {
        text: '异常数量',
        textStyle: {
          color: '#fff',
          fontSize: 12,
          fontWeight: 'lighter'
        },
        left: '10%',
        top: '20%'
      },
      tooltip: {
        trigger: 'item',
        formatter: '{b} :{d}%'
      },
      legend: {
        orient: 'vertical',
        left: 'right',
        top: '20%',
        data: data.map(d => ({ name: d.name, textStyle: { color: '#fff' } }))
      },
      series: [
        {
          name: '比例',
          type: 'pie',
          radius: ['50%', '65%'],
          avoidLabelOverlap: false,
          label: {
            normal: {
              position: 'center',
              /*formatter : function(abnormalTotal){

                return abnormalTotal+'辆'
              },*/
              formatter: abnormalTotal + '辆',
              textStyle: {
                fontSize: '15',
                color: 'red'
              }
            },
            emphasis: {
              show: true,
              textStyle: {
                fontSize: '15',
                fontWeight: 'bold'
              }
            }
          },
          labelLine: {
            normal: {
              show: false
            }
          },
          data: data,
          z: 3
        }
      ]
    };
  }
}
