import React from 'react';
import { Form, Row, Col, Button } from 'antd';
import styles from './StoreForm.scss';
import { Link } from 'react-router-dom';

export default class StoreForm extends React.Component {
  handleShowModal = () => () => {
    this.props.showModal();
  };

  render() {
    return (
      <Form className={styles.form}>
        <Row>
          <Col span={2} className={styles.addButton}>
            <Link to="/companies">{`< 返回`}</Link>
          </Col>
        </Row>
        <Row>
          <Col span={2} className={styles.addButton}>
            <Button onClick={this.handleShowModal()}>新增门店</Button>
          </Col>
        </Row>
      </Form>
    );
  }
}
