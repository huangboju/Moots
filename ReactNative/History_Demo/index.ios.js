/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
import React, { Component } from 'react';
import Detail from './Detail'
import {
  AppRegistry,
  Image,
  ListView,
  StyleSheet,
  TouchableHighlight,
  Text,
  View
} from 'react-native'

var REQUEST_URL = 'http://test.cmcaifu.com/api/v1/products/history/?page_size=10';
var Dimensions = require('Dimensions');
var NavigationBar = require('react-native-navbar');

var History_Demo = React.createClass({
  getInitialState() {
    return {
      dataSource: new ListView.DataSource({
        rowHasChanged: (row1, row2) => row1 !== row2,
      }),
      loaded: false,
    };
  },

  componentDidMount() {
    this.fetchData();
  },

  fetchData() {
    fetch(REQUEST_URL)
      .then((response) => response.json())
      .then((responseData) => {
        this.setState({
          dataSource: this.state.dataSource.cloneWithRows(responseData.results),
          loaded: true,
        });
      })
      .done();
  },

  render() {
    if (!this.state.loaded) {
      return this.renderLoadingView();
    }
    const rightButtonConfig = {
      title: 'Next',
      handler: () => alert('hello!'),
    };

    const titleConfig = {
      title: '历史产品'
    };
    return (
      <View style={{flex: 1}}>
        <NavigationBar
          title={titleConfig}
          rightButton={rightButtonConfig}
          tintColor={'#FF9600'}
          barTintColor='white'/>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this.renderHistory}
          style={styles.listView}
        />
      </View>
    );
  },

  renderLoadingView() {
    return (
      <View style={styles.container}>
        <Text>
          Loading movies...
        </Text>
      </View>
    );
  },

  showBookDetail() {

      this.props.navigator.push({
          title: book.volumeInfo.title,
          component: Detail
      });
  },

  renderHistory(history) {
    return (
      <TouchableHighlight onPress={() => this.showBookDetail()} underlayColor='#dddddd'>
        <View>
          <View style={styles.container}>
            <View style={styles.rightContainer}>
                <Text style={styles.name}>{history.name}</Text>
                <Text style={styles.message}>{history.status.message}</Text>
              <View style={styles.separator}/>
                <Text style={styles.rate}>{history.rate / 100 + '%'}</Text>
                <Text style={styles.rateText}>{'年化利率'}</Text>
                <Text style={styles.period}>{history.period + '天'}</Text>
                <Text style={styles.periodText}>{'投资期限'}</Text>
                <Text style={styles.count}>{history.orders.count + '人'}</Text>
                <Text style={styles.countText}>{'投资人数'}</Text>
              </View>
            </View>
          <View style={styles.section} />
        </View>
      </TouchableHighlight>
    );
  },
});

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: 120
  },
  rightContainer: {
    flex: 1,
    padding: 10,
  },
  separator: {
      height: 0.5,
      marginTop: 5,
      backgroundColor: '#DDDDDD',
  },
  section: {
    height: 5,
    backgroundColor: '#DDDDDD',
  },
  name: {
    marginTop: -20,
  },
  message: {
    textAlign: 'right',
    width: 50,
    textAlign: 'center',
    borderWidth: 1,
    borderColor: '#D3D3D3',
    marginTop: -15,
    marginLeft: 250,
    borderRadius: 3
  },
  rate: {
    color: '#FF9600',
    width: 58,
    textAlign: 'center',
    backgroundColor: '#4682B4',
    marginTop: 9
  },
  rateText: {
    marginTop: 15,
    width: 58,
    backgroundColor: '#0000FF',
  },
  period: {
    color: '#FF9600',
    marginLeft: 100,
    marginTop: -46,
    textAlign: 'center',
    width: 58,
    backgroundColor: '#FF0000',
  },
  periodText: {
    marginLeft: 100,
    marginTop: 15,
    width: 58,
    backgroundColor: '#FF0000',
  },
  count: {
    marginLeft: 200,
    color: '#FF9600',
    textAlign: 'center',
    marginTop: -45,
    width: 58,
    backgroundColor: '#7FFF00',
  },
  countText: {
    marginLeft: 200,
    marginTop: 15,
    width: 58,
    backgroundColor: '#FFD700',
  },
  listView: {
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('History_Demo', () => History_Demo);
