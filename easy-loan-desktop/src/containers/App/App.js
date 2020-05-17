import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Route, Switch, Redirect } from 'react-router-dom';
import { Layout, Spin, Row } from 'antd';
import { Sider, Header, Content, Footer } from 'components';
import LoanList from '../Loan/ListPage';
import RepaymentList from '../Repayment/ListPage';
import TransferList from '../Transfer/ListPage';
import InventoryList from '../Inventory/ListPage';
import FounderInventoryList from '../FounderInventory/ListPage';
import CompanyList from '../Company/ListPage';
import StoreList from '../Store/ListPage';
import DetailList from '../InventoryDetail/ListPage';
import FounderDetailList from '../FounderInventoryDetail/ListPage';
import UserList from '../User/ListPage';
import RoleList from '../Role/ListPage';
import { fetch } from '../../models/reducers/profile';
import { logout } from '../../models/reducers/auth';

const menus = [
  {
    key: '1',
    text: '库融借款',
    icon: 'pay-circle-o',
    path: '/loans',
    authority: auths => auths.some(elem => ['借款单查看'].includes(elem))
  },
  {
    key: '2',
    text: '库融还款',
    icon: 'check-circle-o',
    path: '/repayments',
    authority: auths => auths.some(elem => ['还款单查看'].includes(elem))
  },
  {
    key: '3',
    text: '库融换车',
    icon: 'sync',
    path: '/transfer',
    authority: auths => auths.some(elem => ['换车单查看'].includes(elem))
  },
  {
    key: '4',
    text: '库融盘库',
    icon: 'inbox',
    path: '/inventory',
    authority: auths => auths.some(elem => ['盘库管理'].includes(elem)),
    children: [
      {
        key: '11',
        path: /inventory\/[0-9]*/,
        icon: 'auto',
        text: '盘库详情',
        authority: '盘库管理'
      }
    ]
  },
  {
    key: '5',
    text: '资金方盘库',
    icon: 'database',
    path: '/inventorys/funderCompany',
    authority: auths => auths.some(elem => ['资方盘库管理'].includes(elem)),
    children: [
      {
        key: '12',
        path: /inventorys\/funderCompany\/[0-9]*/,
        icon: 'auto',
        text: '盘库详情',
        authority: '资方盘库管理'
      }
    ]
  },

  {
    key: '6',
    text: '商家',
    icon: 'shop',
    path: '/companies',
    authority: '车商查看',
    children: [
      {
        key: '7',
        path: /companies\/[0-9]*/,
        icon: 'auto',
        text: '测试车商',
        authority: '车商信息管理'
      }
    ]
  },
  {
    key: '8',
    text: '设置',
    icon: 'tool',
    children: [
      {
        key: '9',
        text: '员工',
        icon: 'user',
        path: '/users',
        authority: '员工管理'
      },
      {
        key: '10',
        text: '角色',
        icon: 'team',
        path: '/roles',
        authority: '角色管理'
      }
    ]
  }
];

const filterByAuthorities = (auths, menus) => {
  if (!menus || !auths) return [];
  return menus.reduce((acc, menu) => {
    if (menu.children) {
      const children = filterByAuthorities(auths, menu.children);
      if (children.length > 0) acc.push({ ...menu, children });
    } else if (typeof menu.authority === 'function') {
      if (menu.authority(auths)) acc.push(menu);
    } else if (typeof menu.authority === 'string') {
      if (auths.includes(menu.authority)) acc.push(menu);
    }
    return acc;
  }, []);
};

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      collapsed: true
    };
  }

  componentDidMount() {
    const { loaded, fetch } = this.props;
    if (!loaded) fetch();
  }

  toggle = collapsed => {
    this.setState({
      collapsed: !this.state.collapsed
    });
  };

  render() {
    const { match, loaded, logout, currentUser, pageTitle } = this.props;
    if (!loaded) {
      return (
        <Row
          style={{ height: '100vh' }}
          type="flex"
          justify="center"
          align="middle"
        >
          <Spin size="large" />
        </Row>
      );
    }

    const menuData = filterByAuthorities(currentUser.authorities, menus);
    return (
      <Layout style={{ height: '100vh' }}>
        <Sider collapsed={this.state.collapsed} menuData={menuData} />
        <Layout style={{ overflow: 'scroll' }}>
          <Header
            toggleSider={this.toggle}
            siderCollapsed={this.state.collapsed}
            menuData={menuData}
            logout={logout}
            currentUser={currentUser}
            pageTitle={pageTitle}
          />
          <Content>
            <Switch>
              <Route path={`${match.url}loans`} component={LoanList} />
              {/*<Route path="/companies/:sid" component={StoreList}/>*/}
              <Route
                path={`${match.url}companies/:sid`}
                component={StoreList}
              />
              <Route
                path={`${match.url}inventory/:did`}
                component={DetailList}
              />
              <Route
                path={`${match.url}inventorys/funderCompany/:cid`}
                component={FounderDetailList}
              />
              <Route
                path={`${match.url}repayments`}
                component={RepaymentList}
              />
              <Route path={`${match.url}transfer`} component={TransferList} />
              <Route path={`${match.url}inventory`} component={InventoryList} />
              <Route
                path={`${match.url}inventorys/funderCompany`}
                component={FounderInventoryList}
              />
              <Route path={`${match.url}companies`} component={CompanyList} />
              <Route path={`${match.url}users`} component={UserList} />
              <Route path={`${match.url}roles`} component={RoleList} />
              <Route exact path={`${match.url}`} component={LoanList} />
              <Redirect to="/404" />
            </Switch>
          </Content>
          <Footer>Footer</Footer>
        </Layout>
      </Layout>
    );
  }
}

App.propTypes = {
  currentUser: PropTypes.object,
  fetch: PropTypes.func.isRequired,
  logout: PropTypes.func.isRequired
};

export default connect(
  state => ({
    currentUser: state.profile.user,
    loaded: state.profile.loaded,
    pageTitle: state.layout.pageTitle
  }),
  { fetch, logout }
)(App);
