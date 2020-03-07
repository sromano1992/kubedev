import React from 'react';
import { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import Form from 'react-bootstrap/Form'
import Button from 'react-bootstrap/Button'
import Col from 'react-bootstrap/Col'
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'
import Card from 'react-bootstrap/Card'
import Figure from 'react-bootstrap/Figure'
import Alert from 'react-bootstrap/Alert'
import $ from 'jquery';

class App extends React.Component {

  constructor(props) {
    super(props);
    this.amount = React.createRef();
  }

  toggleButtonState = () => {
    console.log("here!")
    $.ajax({
      type: 'GET',
      url: 'http://localhost:5000/data/message',
      success: function(data) { 
        console.log('backend response received!' + data['result']['message']); 
        $('#message').append(data['result']['message']);
      },
      error: function() { alert('Failed!'); }
    })
    
  };

  render(){
    return (
      <div className="App">
        
        <Container>
          <Row>
            <Col>
                <Alert variant='primary'>
                  
                  <Alert.Link href="#">Architectural context</Alert.Link>
                  
                </Alert>
              <Figure>
                  <Figure.Image
                    width={600}
                    height={480}
                    alt="architecturalContext"
                    src="backendContext.png"
                  />
              </Figure>
            </Col>
            <Col xs={6}>
              <Button onClick={this.toggleButtonState} variant="primary">
                  Call backend
              </Button>
              <h1 id='message'></h1>
            </Col>
          </Row>
        </Container>
        
      </div>
    );
  }
}

export default App;
